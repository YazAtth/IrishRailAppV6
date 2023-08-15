
class DeparturesFilterController < ApplicationController

  def index

    departures_controller = DeparturesController.new
    response = departures_controller.make_request("http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML")["body"]["ArrayOfObjStation"]["objStation"]

    @station_names = []
    response.each do |station|
      @station_names.append(station["StationDesc"])
    end


  end

  def search
    origin_station = params[:origin_station]
    destination_station = params[:destination_station]

    session[:origin_station] = origin_station
    session[:destination_station] = destination_station

    # p origin_station

    redirect_to departures_page_path
  end


  def set_journey
    session[:origin_station] = params[:origin_station]
    session[:destination_station] = params[:destination_station]

    redirect_to departures_page_path
  end
end