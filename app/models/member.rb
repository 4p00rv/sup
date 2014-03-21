class Member < ActiveRecord::Base
  has_many(
    :group_members,
    :class_name => "GroupMember",
    :foreign_key => :member_id,
    :primary_key => :id
  )
  has_many(
    :groups,
    :through => :group_members,
    :source => :group
  )

  has_many :meeting_members
  has_many :meetings, through: :meeting_members

  attr_accessible :name, :email, :group_ids, :left_out
  accepts_nested_attributes_for :groups

  def edges
    met_members = meetings.map(&:members).flatten.map(&:email)
    group_members = fellow_members.map(&:email)
    met_members.concat(group_members).uniq
  end

  def edge_ids
    met_members = meetings.map(&:members).flatten.map(&:id)
    group_members = fellow_members.map(&:id)
    met_members.concat(group_members).uniq
  end

  def fellow_members
    groups.map(&:members).flatten - [self]
  end
end
#--
# generated by 'annotated-rails' gem, please do not remove this line and content below, instead use `bundle exec annotate-rails -d` command
#++
# Table name: members
#
# * id         :integer         not null
#   name       :string(255)
#   email      :string(255)
#   created_at :datetime
#   updated_at :datetime
#   left_out   :boolean
#--
# generated by 'annotated-rails' gem, please do not remove this line and content above, instead use `bundle exec annotate-rails -d` command
#++
