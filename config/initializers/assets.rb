config = YAML.load_file(Rails.root.join('config', 'assets.yml'))[Rails.env]
Rails.application.config.asset_base = config['asset_base']
