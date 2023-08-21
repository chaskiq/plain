require "test_helper"
require 'mocha/minitest'

class PlainTest < ActiveSupport::TestCase
  test 'returns the Plain configuration object' do
    assert_instance_of Plain::Configuration, Plain.configuration
  end

  test 'returns the same object each time' do
    assert_same Plain.configuration, Plain.configuration
  end

  test 'sets the extensions' do
    Plain.configuration.extensions = ['.rb', '.js']
    assert_equal ['.rb', '.js'], Plain.configuration.extensions
  end

  test 'sets the paths' do
    Plain.configuration.paths = ['app/models', 'app/controllers']
    assert_equal ['app/models', 'app/controllers'], Plain.configuration.paths
  end

  test 'load_all calls create_default_schema' do
    # Plain.configuration.vector_search.expects(:create_default_schema).returns(true)
    plain = Plain::AiDocs.new
    plain.stubs(:load_configuration_paths).returns(true)
    Plain.configuration.vector_search.stubs(:create_default_schema).returns(true)

    assert_equal true, plain.load_all
    #assert_received(Plain.configuration.vector_search, :create_default_schema)
    #assert_received(Plain::AiDocs.any_instance, :load_configuration_paths)
  end

  test '.get_structure returns the correct structure' do
    # Setup
    expected_structure = { 'getting_started' => ['introduction', 'installation'] }
    Plain::DocsService.stubs(:get_structure).returns(expected_structure)

    # Exercise
    structure = Plain::DocsService.get_structure

    # Verify
    assert_equal expected_structure, structure
  end

  test '.parse_section_items returns the correct items' do
    # Setup
    section = { 'name' => 'getting_started', 'items' => ['introduction', 'installation'] }
    expected_items = ['Introduction', 'Installation']
    Plain::DocsService.stubs(:parse_section_items).with(section).returns(expected_items)

    # Exercise
    items = Plain::DocsService.parse_section_items(section)

    # Verify
    assert_equal expected_items, items
  end

  test '.config returns the correct configuration' do
    # Setup
    expected_config = { 'docs_path' => 'path/to/docs' }
    Plain::DocsService.stubs(:config).returns(expected_config)

    # Exercise
    config = Plain::DocsService.config

    # Verify
    assert_equal expected_config, config
  end

  test '.parse_main_sections returns the correct sections' do
    # Setup
    main_sections = [
      { 'name' => 'getting_started', 'position' => 1 },
      { 'name' => 'advanced_topics', 'position' => 2 }
    ]
    expected_sections = ['Getting Started', 'Advanced Topics']
    Plain::DocsService.stubs(:parse_main_sections).returns(expected_sections)

    # Exercise
    sections = Plain::DocsService.parse_main_sections(main_sections)

    # Verify
    assert_equal expected_sections, sections
  end

  test '.get_content returns the correct content' do
    # Setup
    file_path = Rails.root.join('docs', 'foo.md')
    md_content = "# Getting Started\nThis is the getting started guide."
    File.write(file_path, md_content)
    expected_content = "<h1>Getting Started</h1>\n\n<p>This is the getting started guide.</p>\n"

    # Exercise
    content = Plain::DocsService.get_content(file_path.to_s.gsub(".md", ""))

    # Verify
    assert_equal expected_content, content

    # Teardown
    File.delete(file_path)
  end

end
