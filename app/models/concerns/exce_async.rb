module ExceAsync
  extend ActiveSupport::Concern

  def exe_async(method, *args)
    job_args = extract_args(method, args)
    AsyncJob.perform_async(*job_args)
  end

  private def extract_args(method, args)
    arity = method(method).arity
    args_size = args&.size&.to_i
    unless arity.negative? || arity === args_size
      raise <<~MSG
              Invalid number of args, #{method}
              expected #{arity} but received #{args_size}
            MSG
    end

    raise "#{self} does not respond to id" unless self.respond_to?(:id)
    [self.class.name, id, method.to_s, args]
  end

end
