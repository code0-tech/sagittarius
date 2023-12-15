# frozen_string_literal: true

RSpec.describe Types::GlobalIdType do
  include GraphqlHelpers

  let_it_be(:user) { create(:user) }

  let(:gid) { user.to_global_id }

  it 'is has the correct name' do
    expect(described_class.graphql_name).to eq('GlobalID')
  end

  describe '.coerce_result' do
    it 'can coerce results' do
      expect(described_class.coerce_isolated_result(gid)).to eq(gid.to_s)
    end

    it 'rejects integer IDs' do
      expect { described_class.coerce_isolated_result(user.id) }.to raise_error(GraphQL::CoercionError)
    end

    it 'rejects strings' do
      expect { described_class.coerce_isolated_result('not a GID') }.to raise_error(GraphQL::CoercionError)
    end
  end

  describe '.coerce_input' do
    it 'can coerce valid input' do
      coerced = described_class.coerce_isolated_input(gid.to_s)

      expect(coerced).to eq(gid)
    end

    it 'handles all valid application GIDs' do
      expect do
        described_class.coerce_isolated_input(build_stubbed(:user_session).to_global_id.to_s)
      end.not_to raise_error
    end

    it 'rejects invalid input' do
      expect do
        described_class.coerce_isolated_input('not valid')
      end.to raise_error(GraphQL::CoercionError, /not a valid Global ID/)
    end

    it 'rejects nil' do
      expect(described_class.coerce_isolated_input(nil)).to be_nil
    end

    it 'rejects GIDs from different apps' do
      invalid_gid = GlobalID.new(URI::GID.build(app: 'otherapp', model_name: 'User', model_id: user.id, params: nil))

      expect do
        described_class.coerce_isolated_input(invalid_gid)
      end.to raise_error(GraphQL::CoercionError, /is not a Sagittarius Global ID/)
    end
  end

  describe 'a parameterized type' do
    let(:type) { described_class[User] }

    it 'is has the correct name' do
      expect(type.graphql_name).to eq('UserID')
    end

    context 'when the GID is appropriate' do
      it 'can coerce results' do
        expect(type.coerce_isolated_result(gid)).to eq(gid.to_s)
      end

      it 'can coerce valid input' do
        expect(type.coerce_isolated_input(gid.to_s)).to eq(gid)
      end
    end

    context 'when the GID is not for an appropriate type' do
      let(:gid) { build_stubbed(:user_session).to_global_id }

      it 'raises errors when coercing results' do
        expect { type.coerce_isolated_result(gid) }.to raise_error(GraphQL::CoercionError, /Expected a User ID/)
      end

      it 'will not coerce IDs to a GlobalIDType' do
        expect { type.coerce_isolated_result(user.id) }.to raise_error(GraphQL::CoercionError, /Expected a User ID/)
      end

      it 'will not coerce invalid input, even if its a valid GID' do
        expect do
          type.coerce_isolated_input(gid.to_s)
        end.to raise_error(GraphQL::CoercionError, /does not represent an instance of User/)
      end
    end

    it 'handles GIDs for invalid resource names gracefully' do
      invalid_gid = GlobalID.new(URI::GID.build(app: GlobalID.app, model_name: 'invalid', model_id: 1, params: nil))

      expect do
        type.coerce_isolated_input(invalid_gid)
      end.to raise_error(GraphQL::CoercionError, /does not represent an instance of User/)
    end
  end
end
