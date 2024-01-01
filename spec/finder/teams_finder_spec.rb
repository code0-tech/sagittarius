# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamsFinder do
  subject { described_class.new(params).execute }

  let!(:first_team) { create(:team) }
  let!(:second_team) { create(:team) }

  let(:params) { {} }

  context 'when no params are given' do
    it { is_expected.to contain_exactly(first_team, second_team) }
  end

  context 'when filtering by id' do
    let(:params) { { id: second_team.id } }

    it { is_expected.to contain_exactly(second_team) }
  end

  context 'when filtering by path' do
    let(:params) { { name: second_team.name } }

    it { is_expected.to contain_exactly(second_team) }
  end

  context 'when setting limit' do
    let(:params) { { limit: 1 } }

    it { is_expected.to contain_exactly(first_team) }
  end

  context 'when setting single' do
    let(:params) { { single: true } }

    it { is_expected.to eq(first_team) }

    context 'when using single_use_last' do
      let(:params) { { single: true, single_use_last: true } }

      it { is_expected.to eq(second_team) }
    end
  end
end
