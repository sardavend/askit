class AsyncJob
  include Sidekiq::Job
  def perform(class_name, id, method, args = [])
    inst = class_name.constantize.find_by(id: id)
    return unless inst

    args.present? ? inst.send(method, *args) : inst.send(method)
  end
end
