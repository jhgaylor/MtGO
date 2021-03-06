class Card < ApplicationRecord
  has_and_belongs_to_many :subtypes
  has_and_belongs_to_many :supertypes
  has_and_belongs_to_many :types
  has_and_belongs_to_many :printings
  has_and_belongs_to_many :colors
  has_and_belongs_to_many :legalities
  has_many :rulings
  has_many :foreign_names
  has_and_belongs_to_many :deck

  has_many :deck_archives
  has_many :decks, :through => :deck_archives

  def self.write_card_to_database(card_info)
    card = Card.find_or_create_by(:multiverse_id => card_info.multiverse_id)
    card.update_attributes(
      :name => card_info.name,
      :multiverse_id => card_info.multiverse_id,
      :layout => card_info.layout,
      :mana_cost => card_info.mana_cost,
      :cmc => card_info.cmc,
      :rarity => card_info.rarity,
      :text => card_info.text,
      :flavor => card_info.flavor,
      :artist => card_info.artist,
      :number => card_info.number,
      :power => card_info.power,
      :toughness => card_info.toughness,
      :loyalty => card_info.loyalty,
      :variations => card_info.variations,
      :watermark => card_info.watermark,
      :border => card_info.border,
      :timeshifted => card_info.timeshifted,
      :hand => card_info.hand,
      :life => card_info.life,
      :reserved => card_info.reserved,
      :release_date => card_info.release_date,
      :starter => card_info.starter,
      :original_text => card_info.original_text,
      :original_type => card_info.original_type,
      :source => card_info.source,
      :image_url => card_info.image_url,
      :set => card_info.set,
      :set_name => card_info.set_name
    ) # closes card.update_attributes

    unless card_info.colors.nil?
      card_info.colors.each do |card_color|
        color = Color.find_or_create_by(:color => card_color)
        card.colors << color
      end
    end

    unless card_info.types.nil?
      card_info.types.each do |card_type|
        type = Type.find_or_create_by(:name => card_type)
        card.types << type
      end
    end

    unless card_info.supertypes.nil?
      card_info.supertypes.each do |card_supertype|
        supertype = Supertype.find_or_create_by(:name => card_supertype)
        card.supertypes << supertype
      end
    end

    unless card_info.subtypes.nil?
      card_info.subtypes.each do |card_subtype|
        subtype = Subtype.find_or_create_by(:name => card_subtype)
        card.subtypes << subtype
      end
    end

    unless card_info.rulings.nil?
      card_info.rulings.each do |card_ruling|
        ruling = Ruling.find_or_create_by(:date => card_ruling.date, :text => card_ruling.text)
        # card.rulings << rulings
        ruling.card = card
        ruling.save
      end
    end

    unless card_info.foreign_names.nil?
      card_info.foreign_names.each do |card_foreign|
        foreign_name = ForeignName.find_or_create_by(:name => card_foreign.name, :language => card_foreign.language, :multiverse_id => card_foreign.multiverse_id )
        foreign_name.card = card
        foreign_name.save
      end
    end

    unless card_info.printings.nil?
      card_info.printings.each do |card_printing|
        printing = Printing.find_or_create_by(:set => card_printing)
        card.printings << printing
      end
    end

    unless card_info.legalities.nil?
      card_info.legalities.each do |card_legality|
        legality = Legality.find_or_create_by(:legality => card_legality.legality, :format => card_legality.format)
        card.legalities << legality
      end
    end

    card.save
    return card # a Rubyist would say not to type "return", to just type card
  end # end def write_card_to_database(card_info)


  def hasImage?
    !(image_url == "" || image_url.nil?) # return true if image_url is not an empty string AND it is not nil
  end # end def hasImage

end # end class Card
