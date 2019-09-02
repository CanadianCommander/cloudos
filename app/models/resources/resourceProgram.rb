module Resources
  class ResourceProgram < Resource

    def self.new_resource_program(program_id, path)
      ActiveRecord::Base.transaction do
        resource = ResourceProgram.create(path: path)
        System::ProgramResource::new_program_resource(program_id, resource.id)
        return resource
      end
    end

    has_one :program_resource, :class_name => 'System::ProgramResource', :foreign_key => "resource_id"
  end
end