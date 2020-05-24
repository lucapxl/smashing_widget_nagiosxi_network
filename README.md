# Veeam Widget for [Smashing](https://smashing.github.io)

[Smashing](https://smashing.github.io) widget that displays a network graph from Nagios XI checks.
Nagios XI API can return mrtg data we can sue to plot in our smashing dashboard

## Example
TODO

## Installation and Configuration

This widget uses `open-uri` and `json`. make sure to add them in your dashboard Gemfile
```Gemfile
gem 'open-uri'
gem 'json'
```
and to run the update command to download and install them.

```shell
$ bundle update
```

Create a ```networkgraph``` folder in your ```widgets``` directory and clone this repository inside it. 
make a symbolic link of the file ```jobs/networkgraph.rb``` in the ```/jobs``` directory of your dashboard.
for example, if your smashing installation directory is in ```/opt/dashboard/``` you would run this:
```Shell
$ ln -s /opt/dashboard/widgets/networkgraph/jobs/networkgraph.rb /opt/dashboard/jobs/networkgraph.rb
```

configure `jobs/networkgraph.rb` job file for your environment:

```ruby
apiKey = 'xxxxxxx' # The API Key generated in your Nagios XI
nagiosHOST = 'your.nagiosxihost.name' # IP Address or Hostname of your Nagios XI server
monitoredhostname = 'C1002ASA01' #Hostname configured in Nagios. this is usually the firewall/router/switch you need to get the graph from
servicedescription = 'Ext_500_V977%20Bandwidth' # The nagios service name. when using the nagios wizard it usually ends with 'Bandwidth'. 
```

add the tile in your dashboard .erb file
```data-max``` should contain the maximum bandwidth to display. in this example is 500Mb

```html
    <li data-row="2" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="networkgraph" data-view="Networkgraph" data-title="Internet" data-graphtype="line" data-max="500"></div>
    </li>   
```

## License

Distributed under the MIT license