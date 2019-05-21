RSpec.shared_examples 'has index action' do
  let(:user) { create(:user) }
  before do
    sign_in user
    get :index
  end
  it { expect(subject).to respond_with(:ok) }
  it { expect(subject).to render_template(:index) }
end
