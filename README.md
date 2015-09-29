# shellout-experimental

Cookbook for installing and reverting experimental mixlib-shellout Gem tracked via https://github.com/chef/mixlib-shellout/pull/110

## Supported environment
This cookbook is intended to be run on the following environment:
* Windows platform
* Chef client 12.2.1 or any version pinned to mixlib-shellout 2.0.1
* Node running under the windows chef-client service

## Installing the experimental gem with this cookbook
This cookbook will download the experimental gem file to the node's temp folder and replace the existing mixlib-shellout gem. Afterwards it will restart the chef-clent service.

*This cookbook must not be added to the nodes runlist.* Attempts to add this cookbook to the runlist and converge the node on its next scheduled run under the chef-client service will fail because the service cannot be restarted by a client running under the same service.

Follow these steps to install the experimental gem with this cookbook:

```
# Clone this cookbook locally
git clone https://github.com/mwrock/shellout-experimental

# Upload the cookbook to your chef server
knife cookbook upload shellout-experimental -o .

# converge nodes using knife winrm
# use the appropriate credentials and chef query that apply to your environment
knife winrm QUERY 'chef-client -o recipe[shellout-experimental]' -x vagrant -P vagrant
```

## Restoring a node to the original gem
To restore a node to the original gem run the restore recipe:
```
knife winrm QUERY 'chef-client -o recipe[shellout-experimental::restore]' -x USER -P PASSWORD
```

## What's different in this experimental gem?
This gem attempts to rectify hangs in chef-client runs on Windows. Under normal circumstances server hangs should not occur, but there have been some reports of chef-client hangiong indefinitely when a node is under heavy load.

The chef-client service has a `watchdog timeout` setting designed to kill a chef-client run that does not complete prior to the timeout. This timeout does not work and the experimental gem corrects the broken timeout.

## Setting the watchdog timeout
The `watchdog_timeout` defaults to 2 hours. You can change this setting in your `client.rb` file:

```
windows_service  ({:watchdog_timeout => 600}) # 10 minutes
```

## Timeout logging
The experimantal gem logs to a file `shellout.txt` in the temp directory of the node. Running under the chef-client service, this file would be located at `c:\windows\temp\shellout.txt`. The log includes entries for each shellout process created and each process forcibly killed at timeout.

One fix the experimental gem includes is the ability to kill child processes so there should be an entry for each child process killed in the timeout. Some of these state that the process failed to be killed. This likely means that the process died before it could be killed. For example, if a chef run spawns cmd, ruby, and powershell, then killing powershell (likely started with a `powershell_script` resource) will cause a failure to be returned to ruby and it will then complete and exit before it is killed. 
