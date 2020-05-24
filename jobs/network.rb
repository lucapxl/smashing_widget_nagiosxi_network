require 'open-uri'
require 'json'

apiKey = 'xxxxxxx'
nagiosHOST = 'x.x.x.x'

monitoredhostname500 = 'hostname'
servicedescription500 = 'servicename%20Bandwidth'

monitoredhostname100 = 'hostname2'
servicedescription100 = 'servicename2%20Bandwith'

arrowDOWN = " <span style='color:#03a1fc'>⬇</span>"
arrowUP = " <span style='color:#dc5945'>⬆</span>"

network500performanceurl = 'http://' + nagiosHOST + '/nagiosxi/api/v1/objects/servicestatus?apikey=' + apiKey + '&host_name=' + monitoredhostname500 + '&service_description=' + servicedescription500 
network100performanceurl = 'http://' + nagiosHOST + '/nagiosxi/api/v1/objects/servicestatus?apikey=' + apiKey + '&host_name=' + monitoredhostname100 + '&service_description=' + servicedescription100 

network500urlBase = 'http://' + nagiosHOST + '/nagiosxi/api/v1/objects/rrdexport?apikey=' + apiKey + '&host_name=' + monitoredhostname500 + '&service_description=' + servicedescription500 
network100urlBase = 'http://' + nagiosHOST + '/nagiosxi/api/v1/objects/rrdexport?apikey=' + apiKey + '&host_name=' + monitoredhostname100 + '&service_description=' + servicedescription100

data500UP = Array.new
data500DOWN = Array.new

data100UP = Array.new
data100DOWN = Array.new

SCHEDULER.every "60s", first_in: 0 do |job|
    
    data500UP.clear
    data500DOWN.clear
    data100DOWN.clear
    data100UP.clear
    data500Info = ''

    hours = 4
    start = DateTime.now - (hours/24.0)
    start = start.to_time.to_i

    network500url = network500urlBase + '&start=' + start.to_s
    network100url = network100urlBase + '&start=' + start.to_s

    # getting data point to create the graph
    resp = Net::HTTP.get_response(URI.parse(network500url))
    jsonData = resp.body
    networkData500 = JSON.parse(jsonData)
    counter = 0
    networkData500['data']['row'].each do |child|
        if child['v'][0] != "NaN" and child['v'][1] != "NaN"
            data500UP.push({ "x" => counter, "y" => child['v'][0].to_f})
            data500DOWN.push({ "x" => counter, "y" => child['v'][1].to_f})
            counter += 1
        end
    end
    # getting performance data to display
    resp = Net::HTTP.get_response(URI.parse(network500performanceurl))
    jsonData = resp.body
    networkPerformanceData500 = JSON.parse(jsonData)
    data500Info = networkPerformanceData500['servicestatus']['performance_data']
    data500Info = arrowDOWN + data500Info[/\in=(.*?)Mb/,1].to_f.round(1).to_s + arrowUP + data500Info[/\out=(.*?)Mb/,1].to_f.round(1).to_s
    send_event(:network500, pointsUP: data500UP, pointsDOWN: data500DOWN, performance: data500Info)
  
    resp = Net::HTTP.get_response(URI.parse(network100url))
    jsonData = resp.body
    networkData100 = JSON.parse(jsonData)
    counter = 0
    networkData100['data']['row'].each do |child|
        if child['v'][0] != "NaN" and child['v'][1] != "NaN"
            data100UP.push({ "x" => counter, "y" => child['v'][0].to_f})
            data100DOWN.push({ "x" => counter, "y" => child['v'][1].to_f})
            counter += 1
        end
    end
    resp = Net::HTTP.get_response(URI.parse(network100performanceurl))
    jsonData = resp.body
    networkPerformanceData100 = JSON.parse(jsonData)
    data100Info = networkPerformanceData100['servicestatus']['performance_data']
    data100Info = arrowDOWN + data100Info[/\in=(.*?)Mb/,1].to_f.round(1).to_s + arrowUP + data100Info[/\out=(.*?)Mb/,1].to_f.round(1).to_s
    send_event(:network100, pointsUP: data100UP, pointsDOWN: data100DOWN, performance: data100Info)
end