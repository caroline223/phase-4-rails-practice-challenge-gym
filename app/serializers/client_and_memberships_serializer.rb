class ClientAndMembershipsSerializer < ActiveModel::Serializer
  attributes :id

  def total_membership_amount
    client = Client.find_by_id(params[:id])
    client.memberships.sum(:charge)
end
end
