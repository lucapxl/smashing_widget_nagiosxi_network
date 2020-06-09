# Network graph from NAGIOS XI bandwith -  Widget for [Smashing](https://smashing.github.io)

[Smashing](https://smashing.github.io) widget that displays a network graph from Nagios XI checks.
Nagios XI API can return rrd data we can sue to plot in our smashing dashboard

## Example
TODO

## Installation and Configuration

This widget uses `rest-client` and `json`. make sure to add them in your dashboard Gemfile
```Gemfile
gem 'rest-client'
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

configure `jobs/networkgraph.rb` job file for your environment. ```toGraph``` is an array of hashes that contains all the different bandwidth you need to monitor. "reference" is the ```data-id``` of the block you need to send the data to. ```host``` and ```service``` refer to the nagios XI item to retrieve

```ruby
apiKey = 'xxxxxxx' # The API Key generated in your Nagios XI
nagiosHOST = 'your.nagiosxihost.name' # IP Address or Hostname of your Nagios XI server
toGraph = [
    {
        "reference" => :network500, # data-id block where to send the data to. see below
        "host"      => "C1002ASA01", # the name of the host in nagios XI
        "service"   => "Ext_500_V977%20Bandwidth" # the "bandwidth" service you need to monitor
    },
    {
        "reference" => :network100,
        "host"      => "C1002ASA01",
        "service"   => "Ext_100_V988%20Bandwidth"
    }
]

```

add the tile in your dashboard .erb file
```data-max``` should contain the maximum bandwidth to display. in this example is 500Mb or 100Mb respectively for 2 different internet lines monitored.
```data-id``` should refer to the same ```reference``` in the ```networkgraph.rb``` job file

```html
    <li data-row="2" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="network500" data-view="Networkgraph" data-title="Internet 500" data-graphtype="line" data-max="500"></div>
    </li>   
    <li data-row="3" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="network100" data-view="Networkgraph" data-title="Internet 100" data-graphtype="line" data-max="100"></div>
    </li>    
```

## License

Distributed under the MIT license