require 'rails_helper'

RSpec.describe Image, type: :model do
  describe 'picture_base64' do
    context ':nil' do
      it 'valid' do
        expect(build(:image, picture_base64: nil)).to be_valid
      end
    end
    context ':empty' do
      it 'valid' do
        expect(build(:image, picture_base64: '')).to be_valid
      end
    end
    context ':correct base64 format' do
      context ':png' do
        it 'valid' do
          expect(build(:image)).to be_valid
        end
      end
      context ':jpg' do
        let(:image) { build(:image, picture_base64: Base64.strict_encode64(File.open(::Rails.root.join('spec', 'fixtures', '13KB.jpg')).read)) }

        it 'valid' do
          expect(image).to be_valid
        end
      end
      context ':gif' do
        let(:image) { build(:image, picture_base64: Base64.strict_encode64(File.open(::Rails.root.join('spec', 'fixtures', '1MB.gif')).read)) }

        it 'valid' do
          expect(image).to be_valid
        end
      end
    end
    context ':not base64 format' do
      let(:image) { build(:image, picture_base64: 'dumy') }

      it 'invalid' do
        expect(image).not_to be_valid
      end

      describe 'errors' do
        before { image.valid? }

        it do
          expect(image.errors.full_messages[0]).to eq("picture_base64 is invalid")
        end
      end
    end
    context ':not image (base64 format)' do
      let(:image) { build(:image, picture_base64: Base64.strict_encode64(File.open(::Rails.root.join('spec', 'fixtures', 'not_image.txt')).read)) }

      it 'invalid' do
        expect(image).not_to be_valid
      end

      describe 'errors' do
        before { image.valid? }

        it do
          expect(image.errors.full_messages[0]).to eq("picture_base64 is invalid")
        end
      end
    end
    context ':file size : 1.megabyte' do
      let(:image) { build(:image, picture_base64: Base64.strict_encode64(File.open(::Rails.root.join('spec', 'fixtures', '1MB.png')).read)) }

      it 'valid' do
        expect(image).to be_valid
      end
    end
    context ':file size > 1.megabyte' do
      let(:image) { build(:image, picture_base64: Base64.strict_encode64(File.open(::Rails.root.join('spec', 'fixtures', '1_1MB.png')).read)) }

      it 'invalid' do
        expect(image).not_to be_valid
      end

      describe 'errors' do
        before { image.valid? }

        it do
          expect(image.errors.full_messages[0]).to eq("picture_base64 must be less than or equal to 1 MiB.")
        end
      end
    end
  end

  context 'upload picture' do
    # NOTE: reloadではattr_accessor値が残るため、findする
    let(:model) { Image.find(create(:image).id) }
    let(:refind_model) { Image.find(model.id) }

    it 'picture_base64 is not saved' do
      expect(model.picture_base64).to eq(nil)
    end
    it "picture attached" do
      expect(model.picture.attached?).to be true
    end

    context 'update model' do
      context 'picture_base64 is specified' do
        context 'override picture' do
          before do
            model.picture_base64 = Base64.strict_encode64(File.open(::Rails.root.join('spec', 'fixtures', 'correct_2.png')).read)
          end

          it "picture attached" do
            model.save!
            expect(refind_model.picture.attached?).to be true
          end
          it "image is changed" do
            expect { model.save! }.to change{ model.picture.checksum }
          end
        end
      end
      context 'picture_base64 not specified' do
        it "picture attached" do
          model.save!
          expect(refind_model.picture.attached?).to be true
        end
        it "image is not changed" do
          expect{
            model.save!
          }.not_to change{ model.picture.checksum }
        end

        context 'picture_base64:nil' do
          before do
            model.picture_base64 = nil
          end

          it "picture attached" do
            model.save!
            expect(refind_model.picture.attached?).to be true
          end
          it "image is not changed" do
            expect{
              model.save!
            }.not_to change{ model.picture.checksum }
          end
        end
        context 'picture_base64:""' do
          before do
            model.picture_base64 = ""
          end

          it "picture attached" do
            model.save!
            expect(refind_model.picture.attached?).to be true
          end
          it "image is not changed" do
            expect{
              model.save!
            }.not_to change{ model.picture.checksum }
          end
        end
      end
    end
  end
end
