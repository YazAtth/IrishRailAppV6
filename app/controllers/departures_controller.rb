require "json"
require "net/http"


class DeparturesController < ApplicationController



  def index

    if session[:origin_station].nil? || session[:destination_station].nil?
      # redirect_to departures_filter_page_path

      @journey_supplied = false
      return
    end

    @journey_supplied = true

    origin_station = session[:origin_station]
    departures_api_endpoint_uri = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByNameXML?StationDesc=#{origin_station}"

    @train_route = request_departures(departures_api_endpoint_uri)
    all_train_departures = @train_route["body"]

    # Checks if there are no trains
    if all_train_departures.nil?
      @no_trains = true
      return
    end

    @train_departures = []


    threads = []
    all_train_departures.each do |departure|
      threads << Thread.new do ||
        train_code = departure["Traincode"].strip
        current_date = Date.today.strftime("%e %b %Y").strip
        train_movement_endpoint_uri = "http://api.irishrail.ie/realtime/realtime.asmx/getTrainMovementsXML?TrainId=#{train_code}&TrainDate=#{current_date}"

        train_movements = make_request(train_movement_endpoint_uri)

        if train_movements["requestStatus"] == 1
          departure["Trainmovements"] = train_movements["body"]["ArrayOfObjTrainMovements"]["objTrainMovements"]
        end
      end
    end
    threads.each(&:join) # Makes program wait for all threads to finish before continuing

    if session[:destination_station] == "All"
      @train_departures = all_train_departures
    else
      all_train_departures.each do |departure|
        is_origin_station_found = false

        departure["Trainmovements"].each do |stop|
          stop_station = stop["LocationFullName"]

          if stop_station == session[:origin_station]
            is_origin_station_found = true
          end

          # Only adds departure to view if it contains the destination_station as a stop
          # AND the destination_station comes after the origin_station (is_origin_station_found == true)
          if stop_station == session[:destination_station] && is_origin_station_found
            @train_departures.append(departure)
            next
          end

        end
      end
    end



    @response_pretty = JSON.pretty_generate(@train_route)
    # print(@response_pretty)

  end


  def make_request(input_uri)
    uri = URI(input_uri)
    response = Net::HTTP.get_response(uri)

    json_response = {}

    if response.is_a?(Net::HTTPSuccess)
      api_response = Hash.from_xml(response.body)

      json_response["requestStatus"] = 1
      json_response["body"] = api_response
    else
      json_response["requestStatus"] = -1
    end

    json_response
  end


  def request_departures(input_uri)
    response = make_request(input_uri)
    response["body"] = response["body"]["ArrayOfObjStationData"]["objStationData"]

    response
  end
end