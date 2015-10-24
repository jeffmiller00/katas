require 'spec_helper'
 
describe LinkedList do
  describe '#new' do
    it 'takes one parameter' do
      expect(LinkedList.new(1,2,3)).to be_an_instance_of LinkedList
    end

    it 'should also work with no params' do
      expect(LinkedList.new).to be_an_instance_of LinkedList
    end
  end

  describe '#tail' do
    before :each do
      @list = LinkedList.new 1, 2, 3
    end

    it 'has the correct head' do
      expect(@list.head.value).to eql(1)
    end

    it 'has the correct tail' do
      expect(@list.tail.value).to eql(3)
    end
  end

  describe '#add_element' do
    before :each do
      @list = LinkedList.new
      @list.add_element 1
      @list.add_element 2
      @list.add_element 3
    end

    it 'has the correct head' do
      expect(@list.head.value).to eql(1)
    end

    it 'has the correct tail' do
      expect(@list.tail.value).to eql(3)
    end
  end

  describe '#print_values' do
    before :each do
      @list = LinkedList.new 12, 99, 37
    end

    expected_output = '12 --> 99 --> 37 --> nil
'
    specify { expect { @list.print_values }.to output(expected_output).to_stdout }
  end

  describe '#reverse' do
    before :each do
      @list = LinkedList.new 12, 99, 37
    end

    standard_output = '12 --> 99 --> 37 --> nil
'
    reversed_output = '37 --> 99 --> 12 --> nil
'
    specify { expect { @list.reverse.print_values }.to output(reversed_output).to_stdout }
    specify { expect { @list.reverse.reverse.print_values }.to output(standard_output).to_stdout }
  end

  describe '#reverse!' do
    before :each do
      @list = LinkedList.new 12, 99, 37
    end

    reversed_output = '37 --> 99 --> 12 --> nil
'
    specify { expect { @list.reverse!.print_values }.to output(reversed_output).to_stdout }

    it 'returns the same list if reversed twice' do
      reversed_list = @list.reverse!
      expect(reversed_list.reverse!).to equal(@list)
    end
  end
end