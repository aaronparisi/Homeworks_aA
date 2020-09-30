class Route < ApplicationRecord
  has_many :buses,
    class_name: 'Bus',
    foreign_key: :route_id,
    primary_key: :id

  def n_plus_one_drivers
    buses = self.buses

    all_drivers = {}
    buses.each do |bus|
      drivers = []
      bus.drivers.each do |driver|
        drivers << driver.name
      end
      all_drivers[bus.id] = drivers
    end

    all_drivers
  end

  def better_drivers_query
    # TODO: your code here
    # create a hash, key=bus_id, value=array_of_driver_names
    buses_w_drivers = self.buses
      .includes(:drivers)

    all_drivers = {}
    buses_w_drivers.each do |bus|
      all_drivers[bus.id] = bus.drivers.to_a.map(&:name)
    end

    return all_drivers
  end
end
