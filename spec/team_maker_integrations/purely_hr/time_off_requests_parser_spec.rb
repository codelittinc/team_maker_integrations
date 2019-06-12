# frozen_string_literal: true

RSpec.describe TeamMakerIntegrations::PurelyHR::TimeOffRequestsParser do
  describe '#time_offs' do
    let(:xml_time_offs) { File.read('spec/fixtures/xmls/timeoffs.xml') }
    let(:xml_time_off) { File.read('spec/fixtures/xmls/timeoff.xml') }

    context 'with multiple data' do
      it 'parses all data' do
        parser = described_class.new xml_time_offs
        expect(parser.time_offs.length).to be 2
      end
    end

    context 'with a single time off request' do
      let(:parser) { described_class.new xml_time_off }
      let(:expected_attributes) do
        {
          id: '7891011',
          status: 'Approved',
          comment: nil,
          date: Date.parse('2019-01-30'),
          deducted: false,
          end_time: DateTime.parse('2019-01-30T12:45:00'),
          first_name: 'Dick',
          hours: '2.500',
          last_name: 'Grayson',
          login_id: 'robin',
          start_time: DateTime.parse('2019-01-30T10:15:00+00:00'),
          submitted_at: Date.parse('2019-01-28'),
          type: 'Appointment',
          user_category: nil
        }
      end

      it 'parses the request' do
        expect(parser.time_offs.length).to be 1
      end

      it 'returns an array of time_off_request' do
        expect(parser.time_offs.first).to be_an_instance_of(TeamMakerIntegrations::PurelyHR::Models::TimeOffRequest)
      end

      it 'builds the model with all data' do
        expect(parser.time_offs.first).to have_attributes expected_attributes
      end
    end

    context 'with an invalid xml content' do
      it 'raises an InvalidXmlError' do
        parser = described_class.new 'this should be a XML content'
        expect { parser.time_offs }.to raise_error(TeamMakerIntegrations::InvalidXmlError)
      end
    end

    context 'with an empty xml content' do
      it 'raises an InvalidXmlError' do
        parser = described_class.new ''
        expect { parser.time_offs }.to raise_error(TeamMakerIntegrations::InvalidXmlError)
      end
    end
  end
end
