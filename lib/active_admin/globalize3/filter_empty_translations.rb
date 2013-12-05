# -*- coding: utf-8 -*-
module ActiveAdmin
  module Globalize3
    module FilterEmptyTranslations
      private
      # Activeadmin-globalize3 renders inputs for all translations,
      # resulting in many empty translations being created by globalize.
      #
      # For instance, given the available locales L1, L2 and L2, the
      # following params would be submitted on 'create':
      #
      # {
      #   :
      #   MODEL => {
      #     "translations_attributes" => {
      #       "0" => {
      #         "locale"=>"L1", "id" => "", ATTR1 => "", ATTR2 => "", ...
      #       }
      #       "1" => {
      #         "locale"=>"L2", "id" => "", ATTR1 => "", ATTR2 => "", ...
      #       }
      #       "2" => {
      #         "locale"=>"L3", "id" => "", ATTR1 => "", ATTR2 => "", ...
      #       }
      #     }
      #   }
      #   :
      # }
      #
      # Given these parameters, globalize3 would create a record for every
      # possible translation - even empty ones.
      #
      # This filter removes all empty and unsaved translations from params
      # and marks empty and saved translation for deletion.
      def filter_empty_translations
        model_class = controller_name.classify.safe_constantize
        if model_class.nil? or not model_class.translates?
          return
        end
        model = controller_name.singularize.to_sym
        params[model][:translations_attributes].each do |k,v|
          if v.values[2..-1].all?(&:blank?)
            if v[:id].empty?
              params[model][:translations_attributes].delete(k)
            else
              params[model][:translations_attributes][k]['_destroy'] = '1'
            end
          end
        end
      end
    end
  end
end
