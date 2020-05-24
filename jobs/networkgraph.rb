require 'open-uri'
require 'json'

########################################################################################################
# make sure you edit these variables to fit your environment
apiKey = 'xxxxxxxxx'
nagiosHOST = 'x.x.x.x'
hours = 4

toGraph = [
    {
        "reference" => :network500, 
        "host"      => "C1002ASA01",
        "service"   => "Ext_500_V977%20Bandwidth"
    },
    {
        "reference" => :network100,
        "host"      => "C1002ASA01",
        "service"   => "Ext_100_V988%20Bandwidth"
    }
]
########################################################################################################

arrowDOWN = " <span style='color:#03a1fc'>⬇</span>"
arrowUP = " <span style='color:#dc5945'>⬆</span>"
data_UP = Array.new
data_DOWN = Array.new

SCHEDULER.every "60s", first_in: 0 do |job|

    start = DateTime.now - (hours/24.0)
    start = start.to_time.to_i

    toGraph.each do |graphchild|
        data_UP.clear
        data_DOWN.clear
        data_INFO = ''

        # getting data point to create the graph
        network_url = 'http://' + nagiosHOST + '/nagiosxi/api/v1/objects/rrdexport?apikey=' + apiKey + '&host_name=' + graphchild['host'] + '&service_description=' + graphchild['service'] + '&start=' + start.to_s

        performance_url = 'http://' + nagiosHOST + '/nagiosxi/api/v1/objects/servicestatus?apikey=' + apiKey + '&host_name=' + graphchild['host'] + '&service_description=' + graphchild['service'] 

        resp = Net::HTTP.get_response(URI.parse(network_url))
        jsonData = resp.body
        network_data = JSON.parse(jsonData)
        counter = 0
        network_data['data']['row'].each do |child|
            if child['v'][0] != "NaN" and child['v'][1] != "NaN"
                data_UP.push({ "x" => counter, "y" => child['v'][0].to_f})
                data_DOWN.push({ "x" => counter, "y" => child['v'][1].to_f})
                counter += 1
            end
        end
        # getting performance data to display
        resp = Net::HTTP.get_response(URI.parse(performance_url))
        jsonData = resp.body
        networkPerformanceData = JSON.parse(jsonData)
        data_INFO = networkPerformanceData['servicestatus']['performance_data']
        data_INFO = arrowDOWN + data_INFO[/\in=(.*?)Mb/,1].to_f.round(1).to_s + arrowUP + data_INFO[/\out=(.*?)Mb/,1].to_f.round(1).to_s
        send_event(graphchild['reference'], pointsUP: data_UP, pointsDOWN: data_DOWN, performance: data_INFO)
    end
end