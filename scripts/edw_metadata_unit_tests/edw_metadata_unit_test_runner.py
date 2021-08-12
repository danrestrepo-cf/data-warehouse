import sys
import inspect
import re
import edw_metadata_unit_tests


def main():
    func_dict = {func_name: func for func_name, func in inspect.getmembers(edw_metadata_unit_tests,
                                                                           predicate=inspect.isfunction)}
    if not re.search(r"_test_[0-9]+$", sys.argv[1]) or sys.argv[1] not in func_dict:
        raise ValueError("EDW metadata unit tests: Invalid test parameter.")
    else:
        function_to_call = func_dict[sys.argv[1]]
        unit_test_output = function_to_call()
        if not unit_test_output:
            exit()
        else:
            return unit_test_output


if __name__ == "__main__":
    main()
