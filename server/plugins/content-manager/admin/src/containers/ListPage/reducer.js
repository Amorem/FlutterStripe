/**
 *
 * ListPage reducer
 *
 */

import { fromJS, List, Map } from 'immutable';
import { toString } from 'lodash';

// ListPage constants
import {
  ADD_ATTR,
  ADD_FILTER,
  CHANGE_PARAMS,
  DELETE_DATA_SUCCESS,
  DELETE_SEVERAL_DATA_SUCCESS,
  GET_DATA,
  GET_DATA_SUCCEEDED,
  ON_CHANGE,
  ON_CLICK_REMOVE,
  ON_CLICK_SELECT,
  ON_CLICK_SELECT_ALL,
  ON_TOGGLE_FILTERS,
  OPEN_FILTERS_WITH_SELECTION,
  REMOVE_ALL_FILTERS,
  REMOVE_ATTR,
  REMOVE_FILTER,
  RESET_DISPLAYED_FIELDS,
  SET_DISPLAYED_FIELDS,
  SET_PARAMS,
  SUBMIT,
  ON_TOGGLE_DELETE_ALL,
} from './constants';

const initialState = fromJS({
  appliedFilters: List([]),
  count: fromJS({}),
  currentModel: '',
  didChangeDisplayedFields: false,
  displayedFields: fromJS([]),
  entriesToDelete: List([]),
  filters: List([]),
  filtersUpdated: false,
  filterToFocus: null,
  isLoading: true,
  params: Map({
    _limit: 10,
    _page: 1,
    _sort: '',
    _q: '',
  }),
  records: fromJS({}),
  showFilter: false,
  showWarningDeleteAll: false,
  updatingParams: false,
});

function listPageReducer(state = initialState, action) {
  switch (action.type) {
    case ADD_ATTR:
      return state
        .update('displayedFields', list => {
          if (action.index !== -1) {
            return list.splice(action.index, 0, fromJS(action.attr));
          }

          return list.push(fromJS(action.attr));
        })
        .update('didChangeDisplayedFields', v => !v);
    case ADD_FILTER:
      return state.update('appliedFilters', list => list.push(Map(action.filter)));
    case DELETE_DATA_SUCCESS:
      return state
        .updateIn(['records', state.get('currentModel')], (list) => (
          list.filter(obj => {
            if (obj._id) {
              return obj._id !== action.id;
            }

            return obj.id !== parseInt(action.id, 10);
          })
        ))
        .updateIn(['count', state.get('currentModel')], v => v = v - 1);
    case DELETE_SEVERAL_DATA_SUCCESS:
      return state
        .update('showWarningDeleteAll', () => false)
        .update('entriesToDelete', () => List([]));
    case CHANGE_PARAMS:
      return state
        .updateIn(action.keys, () => action.value)
        .update('filters', list => {
          // Remove the filters
          if (action.keys.indexOf('_q') !== -1) {
            return List([]);
          }
          return list;
        })
        .update('filtersUpdated', v => {
          // Change the URI
          if (action.keys.indexOf('_q') !== -1) {
            return !v;
          }

          return v;
        })
        .update('updatingParams', () => true);
    case GET_DATA:
      return state
        .update('isLoading', () => true)
        .update('currentModel', () => action.currentModel)
        .update('updatingParams', v => {
          if (action.setUpdatingParams) {
            return true;
          }
          return v;
        });
    case GET_DATA_SUCCEEDED:
      return state
        .update('entriesToDelete', () => List([]))
        .updateIn(['count', state.get('currentModel')], () => action.data[0].count)
        .update('isLoading', () => false)
        .updateIn(['records', state.get('currentModel')], () => List(action.data[1]))
        .update('updatingParams', () => false);
    case ON_CHANGE:
      return state.updateIn(['appliedFilters', action.index, action.key], () => action.value);
    case ON_CLICK_REMOVE:
      return state
        .update('appliedFilters', list => list.splice(action.index, 1))
        .update('filters', list => list.splice(action.index, 1))
        .update('filtersUpdated', v => v = !v);
    case ON_CLICK_SELECT:
      return state.update('entriesToDelete', list => {
        const index = state.get('entriesToDelete').indexOf(toString(action.id));

        if (index !== -1) {
          return list.splice(index, 1);
        }

        return list.concat(toString(action.id));
      });
    case ON_CLICK_SELECT_ALL:
      return state.update('entriesToDelete', () => {
        if (state.get('entriesToDelete').size === 0) {
          return state
            .getIn(['records', state.get('currentModel')])
            .reduce((acc, current) => acc.concat(List([toString(current.id)])), List([]));
        }

        return List([]);
      });
    case ON_TOGGLE_FILTERS:
      return state
        .update('filterToFocus', () => null)
        .update('showFilter', v => !v)
        .update('appliedFilters', () => state.get('filters'));
    case OPEN_FILTERS_WITH_SELECTION:
      return state
        .update('showFilter', () => true)
        .update('appliedFilters', () => state.get('filters'))
        .update('filterToFocus', () => action.index);
    case REMOVE_ALL_FILTERS:
      return state
        .update('appliedFilters', () => List([]))
        .update('filters', () => List([]))
        .update('filtersUpdated', v => v = !v);
    case REMOVE_ATTR:
      return state
        .update('displayedFields', list => {
          return list.splice(action.index, 1);
        })
        .update('didChangeDisplayedFields', v => !v);
    case REMOVE_FILTER:
      return state.update('appliedFilters', list => list.splice(action.index, 1));
    case RESET_DISPLAYED_FIELDS:
      return state
        .update('displayedFields', () => fromJS(action.fields))
        .update('didChangeDisplayedFields', v => !v);
    case SET_DISPLAYED_FIELDS:
      return state.update('displayedFields', () => fromJS(action.fields));
    case SET_PARAMS:
      return state
        .update('params', () => Map(action.params))
        .update('filters', () => fromJS(action.filters))
        .update('showFilter', () => false);
    case SUBMIT:
      return state
        .update('filters', () => state.get('appliedFilters').filter(filter => filter.get('value') !== ''))
        .update('appliedFilters', (list) => list.filter(filter => filter.get('value') !== ''))
        .update('showFilter', () => false)
        .update('filtersUpdated', v => v = !v)
        .updateIn(['params', '_q'], () => '');
    case ON_TOGGLE_DELETE_ALL:
      return state.update('showWarningDeleteAll', v => v = !v);
    default:
      return state;
  }
}

export default listPageReducer;
