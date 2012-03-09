module PrawnReport
  class Engine < ::Rails::Engine
    initializer "application_controller.initialize_prawn_report" do
      ActiveSupport.on_load(:action_controller) do
        #include PrawnReport
      end
    end
  end
end
