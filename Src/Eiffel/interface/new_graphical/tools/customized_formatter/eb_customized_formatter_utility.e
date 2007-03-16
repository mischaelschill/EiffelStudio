indexing
	description: "Utility used for customized formatter/tool"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_CUSTOMIZED_FORMATTER_UTILITY

inherit
	SHARED_BENCH_NAMES

	EB_CUSTOMIZED_FORMATTER_XML_CONSTANTS

feature -- Access

	items_from_parsing (a_parse_agent: PROCEDURE [ANY, TUPLE [XM_CALLBACKS]]; a_callback: XM_CALLBACKS_FILTER; a_result_retriever: FUNCTION [ANY, TUPLE, LIST [like item_anchor]]; a_error_retriever: FUNCTION [ANY, TUPLE, EB_METRIC_ERROR]): TUPLE [items: LIST [like item_anchor]; error: EB_METRIC_ERROR] is
			-- Setup related callbacks including `a_callback' for parsing definition xml and call `a_parse_agent' with those callbacks.
			-- Store descriptors retrieved from `a_result_retriever' after parsing in `items'.
			-- If error occurred, it will be stored in `error' which is retrieved from `a_error_retriever', otherwise, `error' will be Void.
		require
			a_parse_agent_attached: a_parse_agent /= Void
			a_callback_attached: a_callback /= Void
			a_result_retriever_attached: a_result_retriever /= Void
			a_error_retriever_attached: a_error_retriever /= Void
		local
			l_retried: BOOLEAN
			l_ns_cb: XM_NAMESPACE_RESOLVER
			l_content_filter: XM_CONTENT_CONCATENATOR
			l_history_filter: EB_XML_LOCATION_HISTORY_FILTER
			l_filters: ARRAY [XM_CALLBACKS_FILTER]
			l_filter_factory: XM_CALLBACKS_FILTER_FACTORY
			l_error: EB_METRIC_ERROR
			l_items:  LIST [like item_anchor]
		do
			create {LINKED_LIST [like item_anchor]} l_items.make
			if not l_retried then
				create l_ns_cb.make_null
				create l_content_filter.make_null
				create l_history_filter.make
				create l_filter_factory

				l_history_filter.set_history_item_output_function (agent metric_names.xml_location ({STRING}?, Void))
				create l_filters.make (1, 4)
				l_filters.put (l_ns_cb, 1)
				l_filters.put (l_content_filter, 2)
				l_filters.put (l_history_filter, 3)
				l_filters.put (a_callback, 4)

				a_parse_agent.call ([l_filter_factory.callbacks_pipe (l_filters)])
				l_items.append (a_result_retriever.item (Void))
			else
				l_error := a_error_retriever.item (Void)
				if l_error /= Void then
					l_error.set_location (l_history_filter.location)
				end
			end
			Result := [l_items, l_error]
		ensure
			result_attached: Result /= Void
		rescue
			l_retried := True
			retry
		end

	xml_document_for_items (a_root_element_name: STRING; a_descriptors: LIST [like item_anchor]; a_xml_generator: FUNCTION [ANY, TUPLE [a_item: like item_anchor; a_parent: XM_COMPOSITE], XM_ELEMENT]): XM_DOCUMENT is
			-- Xml document for `a_descriptors' generated by `a_xml_generator'
		require
			a_root_element_name_attached: a_root_element_name /= Void
			not_a_root_element_name_is_empty: not a_root_element_name.is_empty
			a_descriptors_attached: a_descriptors /= Void
			a_xml_generator_attached: a_xml_generator /= Void
		local
			l_cursor: CURSOR
			l_root: XM_ELEMENT
		do
			create Result.make_with_root_named (a_root_element_name, create {XM_NAMESPACE}.make_default)
			l_cursor := a_descriptors.cursor
			from
				l_root := Result.root_element
				a_descriptors.start
			until
				a_descriptors.after
			loop
				l_root.force_last (a_xml_generator.item ([a_descriptors.item, Result]))
				a_descriptors.forth
			end
			a_descriptors.go_to (l_cursor)
		ensure
			result_attached: Result /= Void
		end

	items_from_xml_document (a_document: XM_DOCUMENT; a_callback: XM_CALLBACKS_FILTER ; a_result_retriever: FUNCTION [ANY, TUPLE, LIST [like item_anchor]]; a_error_retriever: FUNCTION [ANY, TUPLE, EB_METRIC_ERROR]): LIST [like item_anchor] is
			-- Formatter descriptors from `a_document'
		require
			a_document_attached: a_document /= Void
		local
			l_desp_tuple: like items_from_parsing
		do
			l_desp_tuple := items_from_parsing (agent a_document.process_to_events, a_callback, a_result_retriever, a_error_retriever)
			check l_desp_tuple.error = Void end
			Result := l_desp_tuple.items
		ensure
			result_attached: Result /= Void
		end

	items_from_file (a_file_name: STRING; a_callback: XM_CALLBACKS_FILTER ; a_result_retriever: FUNCTION [ANY, TUPLE, LIST [like item_anchor]]; a_error_retriever: FUNCTION [ANY, TUPLE, EB_METRIC_ERROR]; a_set_file_error_agent: PROCEDURE [ANY, TUPLE]): like items_from_parsing is
			-- Items from file named `a_file_name' parsed using `a_callback'.
			-- If error occurred, it will be stored in `error'
			-- If failed because of file issue, call `a_set_file_error_agent'.
		require
			a_file_name_attached: a_file_name /= Void
			a_callback_attached: a_callback /= Void
			a_result_retriever_attached: a_result_retriever /= Void
			a_error_retriever_attached: a_error_retriever /= Void
		local
			l_parser: XM_EIFFEL_PARSER
		do
			create l_parser.make
			Result := items_from_parsing (agent parse_file (a_file_name, ?, l_parser, a_set_file_error_agent), a_callback, a_result_retriever, a_error_retriever)

				-- Setup error information.
			if Result.error /= Void then
				Result.error.set_file_location (a_file_name)
				Result.error.set_xml_location ([l_parser.position.column, l_parser.position.row])
			end
--		ensure
--			result_attached: Result /= Void
		end

	satisfied_items (a_descriptors: LIST [like item_anchor]; a_criterion: FUNCTION [ANY, TUPLE [like item_anchor], BOOLEAN]): LIST [like item_anchor] is
			-- Formatter descriptors from `a_descriptors' which satisfy `a_criterion'
			-- If `a_criterion' is Void, all formatter descriptors will be returned.
		require
			a_descriptors_attached: a_descriptors /= Void
		local
			l_fmt_desp: like item_anchor
			l_cursor: CURSOR
		do
			create {LINKED_LIST [like item_anchor]} Result.make
			l_cursor := a_descriptors.cursor
			from
				a_descriptors.start
			until
				a_descriptors.after
			loop
				l_fmt_desp := a_descriptors.item
				if a_criterion = Void or else a_criterion.item ([l_fmt_desp]) then
					Result.extend (l_fmt_desp)
				end
				a_descriptors.forth
			end
			a_descriptors.go_to (l_cursor)
		ensure
			result_attached: Result /= Void
		end

	item_anchor: ANY
			-- Anchor of items

	absolute_file_name (a_path: STRING; a_file_name: STRING): STRING is
			-- File name (with absolute path) whose relative path is `a_path' (`a_path' has the "formatters" sub-path part) and `file_name' part specified by `a_file_name'
		require
			a_path_attached: a_path /= Void
			a_file_name_attached: a_file_name /= Void
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (a_path)
			l_file_name.set_file_name (a_file_name)
			Result := l_file_name.out
		ensure
			result_attached: Result /= Void
		end

feature -- Setting

	store_xml (a_doc: XM_DOCUMENT; a_file: STRING) is
			-- Store xml defined in `a_doc' in file named `a_file'.
		require
			a_doc_attached: a_doc /= Void
			a_file_attached: a_file /= Void
		local
			l_file: KL_TEXT_OUTPUT_FILE
			l_retried: BOOLEAN
			l_printer: XM_INDENT_PRETTY_PRINT_FILTER
			l_filter_factory: XM_CALLBACKS_FILTER_FACTORY
		do
			if not l_retried then
				create l_file.make (a_file)
				create l_filter_factory
				create l_printer.make_null
				l_file.open_write
				l_printer.set_indent ("%T")
				l_printer.set_output_stream (l_file)
				a_doc.process_to_events (l_filter_factory.callbacks_pipe (<<l_printer>>))
				l_printer.flush
				l_file.close
			else
				if l_file /= Void and then not l_file.is_closed then
					l_file.close
				end
			end
		rescue
			l_retried := True
			retry
		end

feature -- Parsing

	parse_file (a_file: STRING; a_callback: XM_CALLBACKS; a_parser: XM_PARSER; a_set_file_error_agent: PROCEDURE [ANY, TUPLE]) is
			-- Parse `a_file' using `a_parser' with `a_callback'.			
			-- Raise exception if error occurs.
			-- If failed because of file issue, call `a_set_file_error_agent'.
		require
			a_file_ok: a_file /= Void and then not a_file.is_empty
			a_callback_attached: a_callback /= Void
			a_parser_attached: a_parser /= Void
			a_set_file_error_agent_attached: a_set_file_error_agent /= Void
		local
			l_file: KL_TEXT_INPUT_FILE
		do
			create l_file.make (a_file)
			l_file.open_read
			if l_file.exists and then l_file.is_open_read then
				a_parser.set_callbacks (a_callback)
				a_parser.parse_from_stream (l_file)
				l_file.close
			else
				if not l_file.is_closed then
					l_file.close
				end
				a_set_file_error_agent.call (Void)
			end
		end

end
