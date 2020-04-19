require 'spec_helper'
RSpec.describe GameManager do
  subject do
    GameManager.new
  end

  describe "#add_entity" do
    it "should add entities to entities array" do 
      e = Entity.new
      subject.add_entity(e)
      expect(subject.entities).to match_array([e, subject.player])
    end
    it "should not add duplicates" do 
      e = Entity.new
      subject.add_entity(e)
      subject.add_entity(e)
      expect(subject.entities).to match_array([e, subject.player])
    end
  end

  describe '#remove_entity' do 
    it 'should remove entity from entities array' do 
      e = Entity.new
      subject.add_entity(e)
      subject.remove_entity(e)
      expect(subject.entities).to_not include(e)
      
      #nothing weird happens when called on entity already non-present
      subject.remove_entity(e)
      expect(subject.entities).to match_array([subject.player])
    end
  end

  describe '#handle_move' do 
    context 'w' do
      # up
    end
    context 'a' do
      # left
    end
    context 's' do
      # down
    end
    context 'd' do
      # right
    end
    context 'q' do
      # debug
    end
    context 'r' do
      # restart
    end
    context 'z' do
      # undo
    end
  end

  describe '#entities_at' do

  end

  describe '#teleporters' do

  end
end