RSpec.shared_examples 'has show action' do |shown_object|
  let(:user) { create(:user) }
  let(:obj) { shown_object != :user ? create(shown_object, user: user) : user }
  before do
    sign_in user
    
    get :show, params: { id: obj.id }
  end
  it { expect(subject).to respond_with(:ok) }
  it { expect(subject).to render_template(:show) }
  it { expect(assigns(shown_object)).to match(obj) }
end
