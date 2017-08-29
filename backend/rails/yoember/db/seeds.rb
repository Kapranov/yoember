if Rails.env.development?
  puts "━━━━━━━━━━━ Creating Invitations ━━━━━━━━━━━"
  CreateInvitationsService.new.call
  puts 'Invitations Total: ' << "#{Invitation.count}"
  puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
end

if Rails.env.test?; end
if Rails.env.production?; end
