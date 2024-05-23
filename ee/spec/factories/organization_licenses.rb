# frozen_string_literal: true

FactoryBot.define do
  factory :organization_license do
    organization

    transient do
      licensee { { company: 'Code0' } }
      start_date { Time.zone.today - 1 }
      end_date { Time.zone.today + 1 }
      restrictions { {} }
      options { {} }
    end

    data do
      data = Code0::License.new(
        licensee: licensee,
        start_date: start_date,
        end_date: end_date,
        restrictions: restrictions,
        options: options
      )
      Code0::License.export(data, 'Code0')
    end
  end
end
