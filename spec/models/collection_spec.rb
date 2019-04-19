require 'spec_helper'

describe Collection do

  it 'should return problem named scopes' do
    expect(Collection.problem_named_scopes).to eq ['old_exports']
  end

  it 'should lambda named scopes appropriately'

end

describe Collection, 'scope :problem_old_exports (diy)' do
  it 'should return empty when no old collections' do
    expect(Collection.problem_old_exports).to be_empty
  end

  it 'should not return old exported collection with end status' do
    [:collected, :canceled, :refused].each do |status|
      collection = CollectionFixture.new(:exported_at => 4.days.ago, :status => status.to_s)
      expect(Collection.problem_old_exports).not_to include(collection), "status: #{status}"
    end
  end

  it 'should return old exported collection without end status' do
    (Collection.status_values - [:collected, :canceled, :refused]).each do |status|
      collection = CollectionFixture.create(:exported_at => 4.days.ago, :status => status.to_s)
      expect(Collection.problem_old_exports).to include(collection), "status: #{status}"
    end
  end
end

describe Collection, 'scope :problem_old_exports (factory_bot)' do
  before do
    Collection.delete_all
  end

  it 'should return empty when no old collections' do
    expect(Collection.problem_old_exports).to be_empty
  end

  # This spec will fail because factory_bot has a problem with the
  it 'should not return old exported collection with end status' do
    [:collected, :canceled, :refused].each do |status|
      collection = build(:collection, :exported_at => 4.days.ago, :status => status.to_s)
      expect(Collection.problem_old_exports).not_to include(collection), "status: #{status}"
    end
  end

  it 'should return old exported collection without end status' do
    skip "This is failing for a weird reason. Not sure if it's related."
    (Collection.status_values - [:collected, :canceled, :refused]).each do |status|
      collection = Collection.create(:purchase => create(:purchase), :exported_at => 4.days.ago, :status => status.to_s)
      expect(Collection.problem_old_exports).to include(collection), "status: #{status}"
    end
  end
end

describe Collection, 'scope :problem_old_exports (machinist)' do
  it 'should not return old exported collection with end status' do
    [:collected, :canceled, :refused].each do |status|
      collection = Collection.make_unsaved(:exported_at => 4.days.ago,
                                           :status => status.to_s)
      expect(Collection.problem_old_exports).not_to include(collection)
    end
  end
end
