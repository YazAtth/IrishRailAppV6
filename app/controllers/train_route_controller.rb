
class TrainRouteController < ApplicationController

  def index
    if params[:train_code].nil?
      @train_code = "N/A"
    else
      @train_code = params[:train_code]
    end

    current_date = Date.today.strftime("%e %b %Y").strip
    train_movement_endpoint_uri = "http://api.irishrail.ie/realtime/realtime.asmx/getTrainMovementsXML?TrainId=#{@train_code}&TrainDate=#{current_date}"

    p train_movement_endpoint_uri

    departures_controller = DeparturesController.new
    @train_route = departures_controller.make_request(train_movement_endpoint_uri)["body"]["ArrayOfObjTrainMovements"]["objTrainMovements"]



  end


end