require 'rails_helper'

describe SanitizationHelper do
  describe '#sanitize_html(html_content)' do
    subject { sanitize_html(html_content) }

    context 'when html string with <script> tag provided' do
      let(:html_content) { '<p>Paragraph<script>alert("hacked!");</script></p>' }

      it 'removes <script> tag' do
        expect(subject).to eq '<p>Paragraph</p>'
      end
    end
  end
end
