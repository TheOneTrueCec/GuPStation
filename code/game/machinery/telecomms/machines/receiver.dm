/*
	The receiver idles and receives messages from subspace-compatible radio equipment;
	primarily headsets. Then they just relay this information to all linked devices,
	which would probably be network hubs.

	Link to Processor Units in case receiver can't send to bus units.
*/

/obj/machinery/telecomms/receiver
	name = "subspace receiver"
	icon_state = "broadcast receiver"
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and process subspace radio activity."
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 30
	circuit = /obj/item/circuitboard/machine/telecomms/receiver

/obj/machinery/telecomms/receiver/receive_signal(datum/signal/subspace/signal)
	if(!on || !istype(signal) || !check_receive_level(signal) || signal.transmission_method != TRANSMISSION_SUBSPACE)
		return
	if(!is_freq_listening(signal))
		return

	signal.levels = list()

	// send the signal to the hub if possible, or a bus otherwise
	if(!relay_information(signal, /obj/machinery/telecomms/hub))
		relay_information(signal, /obj/machinery/telecomms/bus)

/obj/machinery/telecomms/receiver/proc/check_receive_level(datum/signal/subspace/signal)
	//Check if the reciever is in the z level of sender
	if (z in signal.levels)
		return TRUE
	
	if (signal.frequency == FREQ_EXPLORATION)
		//Exploration signals can be transmitted independantly of the z level
		var/turf/source_turf = get_turf(signal.source)
		if(SSmapping.level_has_any_trait(source_turf.z, list(ZTRAIT_BLUESPACE_EXPLORATION, ZTRAIT_AWAY)))
			return TRUE

	//Check for relays

	for(var/obj/machinery/telecomms/hub/H in links)
		for(var/obj/machinery/telecomms/relay/R in H.links)
			if(R.can_receive(signal) && (R.z in signal.levels))
				return TRUE

	return FALSE

//Preset Receivers

//--PRESET LEFT--//

/obj/machinery/telecomms/receiver/preset_left
	id = "Receiver A"
	network = "tcommsat"
	autolinkers = list("receiverA") // link to relay
	freq_listening = list(FREQ_SCIENCE, FREQ_MEDICAL, FREQ_SUPPLY, FREQ_SERVICE)


//--PRESET RIGHT--//

/obj/machinery/telecomms/receiver/preset_right
	id = "Receiver B"
	network = "tcommsat"
	autolinkers = list("receiverB") // link to relay
	freq_listening = list(FREQ_COMMAND, FREQ_ENGINEERING, FREQ_SECURITY, FREQ_EXPLORATION)

	//Common and other radio frequencies for people to freely use
/obj/machinery/telecomms/receiver/preset_right/Initialize()
	. = ..()
	for(var/i = MIN_FREQ, i <= MAX_FREQ, i += 2)
		freq_listening |= i

/obj/machinery/telecomms/receiver/preset_left/birdstation
	name = "Receiver"
	freq_listening = list()

//makeshift receiver used for the circuit, so that we don't
//have to edit radio.dm and other shit
/obj/machinery/telecomms/receiver/circuit
	idle_power_usage = 0
	var/obj/item/integrated_circuit/input/tcomm_interceptor/holder

/obj/machinery/telecomms/receiver/circuit/receive_signal(datum/signal/signal)
	if(!holder.get_pin_data(IC_INPUT, 1))
		return
	if(!signal)
		return
	holder.receive_signal(signal)

// End