require 'carrierwave/orm/mongoid'

class Picture
	
	FINDOPTS = {:with_pictures => true}

	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Search

  	mount_uploader :image, ImageUploader

	field :name, :type => String, :required => true
	field :description, :type => String
	field :date_taken, :type => Time
	field :photographer, :type => String
	field :tags, :type => Array, :default => []
	field :random, :type => Float
	attr_accessible :image, :name, :description, :date_taken, :photographer, :tags, :random

	paginates_per 20

  	embeds_many :assignedrefs

	search_in :name, :description

	before_create :generate_random


	# provide a collection of ids (in an array) from another model (e.g. a tree), and find the images with this as a tag
  # params: Array of tree_ids.to_s
	def self.find_by_assigned_ref_with_id(modelref, options={})
	# TODO: this only finds a tree at the moment
	# TODO: Probaby broken when there are more than 1 trees in the assigned tree
	# TODO: Bit of metaprog here; as can use the model's class name as the type
		options = FINDOPTS.merge(options)
		pics = Picture.where('assignedrefs.ref' => modelref.id.to_s)
	                        .and('assignedrefs.ref_type' => modelref.class.name.downcase)
	    Rails.logger.info(">>>Find_by_RESULT: #{pics.first.inspect}  #{pics.count}")
	   	if options[:result]
	   		return pics unless pics.count != 0
	   		rand_pics = pics.and(:random.lt => rand) if options[:result]  # at the moment this is always :onerandom
	   		until rand_pics.count != 0
	   			rand_pics = pics.and(:random.lt => rand) if options[:result]
	   		end
	   		Rails.logger.info(">>>Find_by_RANDOM: #{rand_pics.first.inspect} #{rand_pics.first.class}  ")
	   		return rand_pics.first
	   	else
	   		return pics
	   	end
	end




	# Overrides the default writer/reader for tags to turn the string into an array
	# TODO: consider other non-word separaters for tags
	def tags=(value)
		#Rails.logger.info(">>>TAGS===: #{value}")
		write_attribute(:tags, value.split(/\W+/))
	end

	# Overrides the tags getter.
	# Joins into string separated by comma
	def tags
		t = read_attribute(:tags)
		t.nil? ? "" : t.join(', ')
	end

	# The user can select multiple pictures to assign to a Tree
	# The list contains an array of picture ids
	def self.add_assigned_pics(tree_id, pic_list)
		pics = self.find(pic_list)
		Rails.logger.info(">>>Add_Assigned_Pics: Treeid: #{tree_id}, <<pic list>> #{pic_list}  <<found metas>> #{pics.count}")
		# meta contains the pictures; tree_id contains the referenced tree; add to the hash {:tree => [id, id]}
		pics.each do |p|
		  Rails.logger.info(">>>Add_Assigned_Pics: Meta: #{p.inspect}")
		  # TODO weed out references to the same trees
		  #
		  #Rails.logger.info(">>>Add_Assigned_Pics_AFTER: Trees: #{trees}")
		  p.assignedrefs.create(:ref => tree_id, :ref_type => "tree")
		end
		true    # TODO what to do if one fails
	end






	private

	def self.tag_ify(tags)
    	tags.split(/,/)
  	end

  	def generate_random
  		self.random = rand
  	end

end
