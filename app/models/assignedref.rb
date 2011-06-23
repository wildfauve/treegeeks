class Assignedref
	include Mongoid::Document

	embedded_in :picture, :inverse_of => :assignedrefs

	field :ref_id
	field :ref
	field :ref_type
end