class House < ApplicationRecord
  has_many :gardeners,
    class_name: 'Gardener',
    foreign_key: :house_id,
    primary_key: :id

  has_many :plants,
    through: :gardeners,
    source: :plants

  def n_plus_one_seeds
    plants = self.plants
    seeds = []
    plants.each do |plant|
      seeds << plant.seeds
    end

    seeds
  end

  def better_seeds_query
    # TODO: your code here
    # create an array of all the seeds in this house
    # we are not just aggregating the seed data, so we need includes
    plants_w_seeds = self.plants
      .includes(:seeds)

    seeds_in_here = []
    plants_w_seeds.each do |plant|
      seeds_in_here << plant.seeds
    end

    return seeds_in_here
  end
end
