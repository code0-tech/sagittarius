# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationsFinder do
  subject { described_class.new(params).execute }

  let!(:first_organization) { create(:organization) }
  let!(:second_organization) { create(:organization) }

  let(:params) { {} }

  context 'when no params are given' do
    it { is_expected.to contain_exactly(first_organization, second_organization) }
  end

  context 'when filtering by id' do
    let(:params) { { id: second_organization.id } }

    it { is_expected.to contain_exactly(second_organization) }
  end

  context 'when filtering by path' do
    let(:params) { { name: second_organization.name } }

    it { is_expected.to contain_exactly(second_organization) }
  end

  context 'when setting limit' do
    let(:params) { { limit: 1 } }

    it { is_expected.to contain_exactly(first_organization) }
  end

  context 'when setting single' do
    let(:params) { { single: true } }

    it { is_expected.to eq(first_organization) }

    context 'when using single_use_last' do
      let(:params) { { single: true, single_use_last: true } }

      it { is_expected.to eq(second_organization) }
    end
  end
end
