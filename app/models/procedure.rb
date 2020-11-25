class Procedure < ApplicationRecord
  belongs_to :police_in_charge, class_name: 'PoliceMan'
  belongs_to :local_prosecution_in_charge, class_name: 'LocalProsecution'

  belongs_to :police_unit_in_charge, class_name: 'PoliceUnit'
  belongs_to :prosecutor_in_charge, class_name: 'Prosecutor'
  has_many :person_in_procedures
  has_many :people, :through => :person_in_procedures
  has_many :crime_in_accuseds
  has_many :crimes, :through => :crime_in_accuseds
  has_many :messages
  belongs_to :creator, class_name: 'User'
  has_many_attached :videos
  has_many_attached :photos
  has_many_attached :documents

  validate :past_date
  validate :empty_address

  validates :photos, file_size: { less_than_or_equal_to: 50.megabytes },
            file_content_type: { allow: ['image/jpeg', 'image/png', 'image/jpg', 'image/bmp'] }

  validates :videos, file_size: { less_than_or_equal_to: 1.gigabytes },
            file_content_type: { allow: ['video/mp4']}

  validates :documents,file_size: { less_than_or_equal_to: 50.megabytes},
            file_content_type: { allow: [ 'application/pdf', 'text/plain'] }

  enum state: {open: 0, close: 1, draft: 2}
  enum classification: {flagrancy: 0, pending_arrest_warrant: 1, both: 2}

  def state
    super.to_s.humanize
  end

  def classification
    super.to_s.humanize
  end

  def created_at_str
    I18n.locale = :es
    I18n.l(self.created_at, format: '%A, %d de %B de %Y a las %H:%M')
  end

  def date_str
    I18n.locale = :es
    I18n.l(self.date_of_arrest, format: '%A, %d de %B de %Y a las %H:%M')
  end

  def past_date
    if date_of_arrest > Date.today
      errors.add(:date_of_arrest, "la fecha no puede ser en el futuro")
    end
  end

  def empty_address
    if address.match(/^$/)
      errors.add(:address, "la direccion no puede ser vacia")
    end
  end

  has_many :taggings
  has_many :tags, through: :taggings
end
