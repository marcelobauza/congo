require 'test_helper'

class ProjectTypeTest < ActiveSupport::TestCase
  test "create" do
    assert_difference 'ProjectType.count' do
      ProjectType.create(
        name: 'Local Comercial',
        color: 'yellow',
        is_active: true,
        abbreviation: 'LC'
      )
    end
  end

  test 'get project type by abbreviation' do
   project_type = ProjectType.get_project_type_by_first_letter 'C'

   assert_equal project_types(:casa).name, project_type.name
   assert_not_equal project_types(:departamento).name, project_type.name
  end
end
