class PoliceUnit < ApplicationRecord
  after_create :create_user
  belongs_to :police_station
  has_many :users
  has_many :procedures

  def create_user
    #Email
    @email = "up"+self.id.to_s+"@fiscalia.com"

    #Password
    @password = 123456789

    User.create(police_unit: self, email: @email, password: "123456789")
  end
end
