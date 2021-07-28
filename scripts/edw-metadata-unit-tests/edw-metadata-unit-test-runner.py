import sys
import inspect
import EdwMetadataUnitTests


def main():
    func_dict = dict((x, y) for x, y in inspect.getmembers(EdwMetadataUnitTests, predicate=inspect.isfunction))
    function_to_call = func_dict[sys.argv[1]]
    unit_test_output = function_to_call()
    if not unit_test_output:
        exit()
    else:
        return unit_test_output


if __name__ == "__main__":
    main()