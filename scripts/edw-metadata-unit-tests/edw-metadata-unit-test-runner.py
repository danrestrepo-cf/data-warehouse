import sys
import inspect
import EdwMetadataUnitTests


def main():
    func_dict = {func_name: func for func_name, func in inspect.getmembers(EdwMetadataUnitTests,
                                                                           predicate=inspect.isfunction)}
    if sys.argv[1] == "query_tester" or sys.argv[1] not in func_dict:
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