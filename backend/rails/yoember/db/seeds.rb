if Rails.env.development?
  puts "━━━━━━━━━━━ Creating Invitations ━━━━━━━━━━━"
  CreateInvitationsService.new.call
  puts 'Invitations Total: ' << "#{Invitation.count}"
  puts "━━━━━━━━━━━ Creating Labraries   ━━━━━━━━━━━"
  CreateLibrariesService.new.call
  puts 'Libraries Total:   ' << "#{Library.count}"
  puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
end

if Rails.env.test?; end
if Rails.env.production?; end
