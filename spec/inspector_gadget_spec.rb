require 'active_support/all'
require './lib/inspector_gadget.rb'

describe InspectorGadget do
  before :all do
    module Rails;end

    def Rails.logger
      @logger ||= Object.new
    end unless Rails.respond_to?(:logger)

    class Test
      def test_instance_method
        'instance_method'
      end

      def self.test_class_method
        'class_method'
      end

      def test_instance_method_with_arg(arg)
        arg
      end

      def self.test_class_method_with_arg(arg)
        arg
      end

      def test_instance_method_with_block(&block)
        block.call
      end

      def self.test_class_method_with_block(&block)
        block.call
      end

      include InspectorGadget
    end

  end

  it 'should log instance methods' do
    Rails.logger.should_receive(:info).with('Test LOG: instance method name: test_instance_method, args: []')
    Rails.logger.should_receive(:info).with('Test LOG: instance method name: test_instance_method, args: [] returned "instance_method"')
    Test.new.test_instance_method.should == 'instance_method'
  end

  it 'should log class methods' do
    Rails.logger.should_receive(:info).with('Test LOG: class method name: test_class_method, args: []')
    Rails.logger.should_receive(:info).with('Test LOG: class method name: test_class_method, args: [] returned "class_method"')
    Test.test_class_method.should == 'class_method'
  end

  it 'should log instance methods with args' do
    Rails.logger.should_receive(:info).with('Test LOG: instance method name: test_instance_method_with_arg, args: ["foo"]')
    Rails.logger.should_receive(:info).with('Test LOG: instance method name: test_instance_method_with_arg, args: ["foo"] returned "foo"')
    Test.new.test_instance_method_with_arg('foo').should == 'foo'
  end

  it 'should log class methods with args' do
    Rails.logger.should_receive(:info).with('Test LOG: class method name: test_class_method_with_arg, args: ["foo"]')
    Rails.logger.should_receive(:info).with('Test LOG: class method name: test_class_method_with_arg, args: ["foo"] returned "foo"')
    Test.test_class_method_with_arg('foo').should == 'foo'
  end

  it 'should log instance methods with block' do
    Rails.logger.should_receive(:info).with('Test LOG: instance method name: test_instance_method_with_block, args: []')
    Rails.logger.should_receive(:info).with('Test LOG: instance method name: test_instance_method_with_block, args: [] returned 2')
    Test.new.test_instance_method_with_block do
      1 + 1
    end.should == 2
  end

  it 'should log class methods with block' do
    Rails.logger.should_receive(:info).with('Test LOG: class method name: test_class_method_with_block, args: []')
    Rails.logger.should_receive(:info).with('Test LOG: class method name: test_class_method_with_block, args: [] returned 2')
    Test.test_class_method_with_block do
      1 + 1
    end.should == 2
  end

end

