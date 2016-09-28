no_err=0
err_invalid_resolution=2
err_invalid_center=3
err_invalid_c=4
err_invalid_width=5
err_invalid_height=6
err_no_output=7
err_illegal_output=8
err_processing_set=9

function run_with_return_value_expected () {
	echo "Running with params: $1"
	echo "..."

	./tp0 $1 >/dev/null 2>/dev/null
	value=$?

	if [ $value -eq $2 ]
		then
			echo "Test OK. Program returned with expected value $2"
		else
			echo "Test FAILED. Program returned with $value. Expected was $2"
	fi

	echo "---------------------------------------------"
}

#gmake clean >/dev/null
#gmake >/dev/null

#Test with no params, should return no_output
run_with_return_value_expected "" $err_no_output

#Test with invalid resolution
run_with_return_value_expected "-r frambuesa" $err_invalid_resolution

#Test with invalid center
run_with_return_value_expected "-c qcyo+0i" $err_invalid_center

#Test with invalid constant
run_with_return_value_expected "-C clapausius;:;:" $err_invalid_c

#Test with invalid width
run_with_return_value_expected "-w mil" $err_invalid_width

#Test with invalid height
run_with_return_value_expected "-H dosmil" $err_invalid_height

#Test Ok file without custom params
run_with_return_value_expected "-o img.pgm" $no_err
rm img.pgm 2>/dev/null

#Test Ok file with params
run_with_return_value_expected "-w 6 -H 5 -o juli.pgm -r 720x1200 -c +0.12-0.08i -C +0.20-0.09i" $no_err
rm juli.pgm 2>/dev/null
