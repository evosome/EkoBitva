## View-layer data holder describing a question to be shown to the player.
class_name QuestionViewData extends RefCounted


#region fields

var number: int = 1
var title: String = ""
var bank_name: String = ""
var bank_color: Color = Color.WHITE
var answer_variants: Array[String] = []

## Seconds given to answer. Negative value means no timeout at all.
var countdown_seconds: int = -1

#endregion


#region static

static func of(
		number: int,
		title: String,
		bank_name: String,
		bank_color: Color,
		answer_variants: Array[String],
		countdown_seconds: int = -1
) -> QuestionViewData:
	var data = QuestionViewData.new()
	data.number = number
	data.title = title
	data.bank_name = bank_name
	data.bank_color = bank_color
	data.answer_variants = answer_variants
	data.countdown_seconds = countdown_seconds
	return data

#endregion
