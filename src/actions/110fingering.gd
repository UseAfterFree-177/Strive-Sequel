extends Node

const category = 'caress'
const code = 'fingering'
const order = 5
var givers
var takers
const canlast = true
const giverpart = ''
const takerpart = 'vagina'
const virginloss = false
const givertags = ['pet','noorgasm']
const takertags = ['pet', 'vagina']
const giver_skill = ['petting']
const taker_skill = ['pussy']
const consent_level = 15

func getname(state = null):
	return "Fingering"

func getongoingname(givers, takers):
	return "[name1] finger[s/1] [names2] puss[y/ies2]."

func getongoingdescription(givers, takers):
	return "[name1] thrust[s/1] [his1] fingers in and out of [names2] [pussy2]."

func requirements():
	var valid = true
	if takers.size() < 1 || givers.size() < 1 || givers.size() + takers.size() > 3:
		valid = false
	for i in givers:
		if i.limbs == false:
			valid = false
	for i in takers:
#		if i.vagina != null || i.person.has_pussy == false:
#			valid = false
		if i.person.sex == 'male':
			valid = false
	return valid

func givereffect(member):
	var effects = {sens = 100, horny = 20}
	return effects

func takereffect(member):
	var effects = {sens = 125, horny = 25}
	return effects

func initiate():
	var text = ''
	if takers[0].person.lust > 30:
		text += "[name1] {^easily:effortlessly} {^get:work:slip:slide}[s/1] [his1] fingers into [names2] [pussy2]"
	else:
		text += "[name1] {^slowly:carefully} {^get:work:slip:slide}[s/1] [his1] fingers into [names2] [pussy2]"
	if takers[0].person.vaginal_virgin == true:
		text += ", {^probing inside:pumping [his1] fingers:stimulating the enterance} without breaking [his2] hymen[/s2]."
	else:
		text += ", {^driving:pumping:pushing} [his1] fingers in and out."
	return text

func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[names2] [pussy2] {^trembles:twitches}, {^responding:reacting} to {^the stimulation:[names1] fingers:[names1] caress} even in [his2] unconcious state."
	#elif member.consent == false:
		#TBD
	elif member.sens < 100:
		text = "[names2] [pussy2] {^presents:gives} some resistance to {^the intrusion:[names1] fingers:[names1] caress}{^, still somewhat unprepared:, not yet fully prepared:}."
	elif member.sens < 300:
		text = "[names2] [pussy2] {^begins:starts} to {^respond:react} to the {^sensation:feeling} of {^[names1] fingers:[names1] caress}."
	elif member.sens < 600:
		text = "[names2] [pussy2] {^trembles:quivers} in {^response:reaction} to the {^sensation:feeling} of {^[names1] fingers:[names1] caress}, [his2] arousal {^made clear:apparent:clearly showing}."
	else:
		text = "[names2] [pussy2] {^violently trembles:clenches:quivers} with every movement of [names1] fingers{^ as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[s/2] toward orgasm:}."
	return text