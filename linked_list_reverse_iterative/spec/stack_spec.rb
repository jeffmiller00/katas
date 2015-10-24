require 'spec_helper'
 
describe Stack do
  describe '#push' do
    before :each do
      @stack = Stack.new
    end

    it 'can push an element onto the stack' do
      @stack.push 1
      expect(@stack.to_a).to eql([1])
    end

    it 'can push several elements onto the stack' do
      @stack.push 1
      @stack.push 2
      @stack.push 3
      expect(@stack.to_a).to eql([1,2,3])
    end
  end

  describe '#pop!' do
    context 'small / empty stacks' do
      before :each do
        @stack = Stack.new
      end

      it 'pops even if it is empty' do
        expect(@stack.pop!).to eql(nil)
      end

      it 'pops an element if there is only one element' do
        @stack.push 1
        expect(@stack.pop!).to eql(1)
        expect(@stack.to_a).to eql([])
      end
    end

    context 'larger stacks' do
      before :each do
        @stack = Stack.new
        @stack.push 1
        @stack.push 2
        @stack.push 3
      end

      it 'can pop an element off the stack' do
        expect(@stack.pop!).to eql(3)
        expect(@stack.to_a).to eql([1, 2])
      end

      it 'can pop a pushed element' do
        @stack.push 'A'
        expect(@stack.pop!).to eql('A')
        expect(@stack.to_a).to eql([1, 2, 3])
      end
    end
  end
end