extends Node

const category = 'fucking'
const code = 'doggy'
const order = 2
var givers
var takers
const canlast = true
const giverpart = 'penis'
const takerpart = 'vagina'
const virginloss = true
const giverconsent = 'basic'
const takerconsent = 'any'
const givertags = ['penis']
const takertags = ['vagina', 'penetration']

func requirements():
	var valid = true
	if takers.size() != 1 || givers.size() != 1:
		valid = false
#	elif givers.size() + takers.size() == 2 && (!givers[0].penis in [takers[0].vagina, takers[0].anus] ):
#		valid = false
	for i in givers:
		if i.person.penis_size == '' && i.strapon == false:
			valid = false
#		elif i.penis != null && givers.size() > 1:
#			valid = false
	for i in takers:
		if i.person.has_pussy == false:
			valid = false
#		elif i.vagina != null && takers.size() > 1:
#			valid = false
	
	return valid

func getname(state = null):
	return "Doggy Style"

func getongoingname(givers, takers):
	return "[name1] fuck[s/1] [name2] doggy style."

func givereffect(member):
	var effects = {sens = 220, horny = 25}
	if member.person.penis_size == '':
		effects.sens /= 1.2
	return effects

func takereffect(member):
	var effects = {sens = 200, horny = 10}
	member.person.metrics.vag += 1
	return effects

#orientation of givers/takers
const rotation1 = Quat(0.0,0.0,0.0,0.0)
const rotation2 = Quat(0.5,0.0,0.0,1.0)

const initiate = ['start_1_doggy','start_2_sexv']

const ongoing = ['main_1_sexv','main_2_sexv','main_3_sex']

const reaction = ['react_1_sex','react_2_sex','react_3_sexv']

const linkset = "sex"


const act_lines = {

start_2_sexv = {
	
	shift = {
	conditions = {
		orifice = ["shift"],
	},
	lines = [
		", {^enjoying:relishing in} the {^fine:perfect} view of [partners2] [ass2]. ",
	]},
	
	insert = {
	conditions = {
		orifice = ["insert"],
	},
	lines = [
		", {^adjusting:rolling} [his2] hips forward to expose [his2] [pussy2]. ",
		", {^pressing:pushing} [his2] upper body downward to expose [his2] [pussy2]. ",
	]},
	
},

main_3_sex = {
	
	locational = {
	conditions = {
	},
	lines = [
		". ",
		" from behind. ",
		" like [an /2]animal[/s2]. ",
	]},
	
},

react_3_sexv = {
	
	default = {
	conditions = {
	},
	lines = [
		" as [name1] [fucks1] [partner2] {^like [an /1]animal[/s1]:like [a /1]dog[/s1] in heat}.",
	]},
	
},

}