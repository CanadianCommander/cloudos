
class Api::System::ProgramManagerServiceTest < ActiveSupport::TestCase
  include Api::System

  test "should get all install programs" do
    programs = ProgramManagerService.instance.getInstallPrograms()
    all_programs = {
      'appOne' => false,
      'appTwo' => false
    }
    programs.each do |program|
      all_programs[program.name] = true
    end

    all_programs.each do |name, found|
      assert found
    end
  end

end
