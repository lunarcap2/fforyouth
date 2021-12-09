window.Cl = window.Cl || {};

Cl['config'] = function () {
	this.ui = {
		name: {
			inputfile: 'ui-input-file',
			inputdate: 'ui-input-date',
		},
	}
	this.ui['className'] = {}; /*������ �ۼ�����*/
	for (var key in this.ui.name) {
		this.ui['className'][key] = (function (value) {
			return !/^\./.test(value) ? '.' + value : value;
		})(this.ui.name[key]);
	}
	return this;
}
Cl['admin'] = function () {
	Cl['config'].call(this);
	this.ui_name = this.ui.name;
	this.ui_className = this.ui.className;
	return this;
}
Cl['admin'].prototype = {
	ui_render: function (_element) {
		var _this = this;
		var $this = !_element.context ? $(_element) : _element;
		var ui_name = this.ui_name;
		var className = this.ui_className;
		(function ($inputfile) { // ��ǲ���� ���� ui������
			if ($inputfile.length) {
				$inputfile.each(function () {
					var $this = $(this);
					$this.attr('data-ui-name', ui_name.inputfile);
					$this.data('uiName', ui_name.inputfile);
					_this.ui_set($this);
				});
			}
		})($this.is(className.inputfile) ? $this : $this.find(className.inputfile));
		(function ($inputdate) { // ����Ʈ��Ŀ ���� ui������
			if ($inputdate.length) {
				$inputdate.each(function () {
					var $this = $(this);
					$this.attr('data-ui-name', ui_name.inputdate);
					$this.data('uiName', ui_name.inputdate);
					_this.ui_set($this);
				});
			}
		})($this.is(className.inputdate) ? $this : $this.find(className.inputdate));

	},
	ui_set: function (_element) {
		var _this = this;
		var $this = !_element.context ? $(_element) : _element;
		var ui_name = this.ui_name;
		var get_name = $this.data('uiName');
		switch (get_name) {
			case ui_name.inputfile:
				_ui_set_inputfile($this);
				break;
			case ui_name.inputdate:
				_ui_set_inputdate($this);
				break;
		}

		function _ui_set_inputdate($this) { //����Ʈ��Ŀ set
			if ($ && $.fn.datepicker) {
				var _options = $this.data('options');
				if(_options && (_options.minDate || _options.maxDate || _options.yearRange)){
					_options.minDate = new Date(_options.minDate);
					_options.maxDate = new Date(_options.maxDate);
					_options.yearRange = _options.yearRange;
				}
				var o = $.extend({
					dateFormat: 'yy-mm-dd',
					monthNamesShort: ['1��', '2��', '3��', '4��', '5��', '6��', '7��', '8��', '9��', '10��', '11��', '12��'],
					dayNamesMin: ['��', '��', 'ȭ', '��', '��', '��', '��'],
					dayNames: ['�Ͽ���', '������', 'ȭ����', '������', '�����', '�ݿ���', '�����'],
					changeMonth: true,
					changeYear: true,
				}, _options);
				$this.datepicker(o).prop('readonly', true);
			}
		}

		function _ui_set_inputfile($this) { //��ǲ���ϰ��� �������� �±�
			/* ui����:S */
			if (!$this.closest('.cmmFileUpload').length) {
				$this.wrap('<div class="cmmFileUpload"></div>');
				$this.wrap('<div class="cmmInputFile"></div>');
				$this.closest('.cmmFileUpload').append('<input type="text" class="read-input" placeholder="" readonly /><span class="btn">����ã��</span>');
			}
			var $cmmFileUpload = $this.closest('.cmmFileUpload');
			var $input_text = $cmmFileUpload.find('input[type="text"].read-input');
			var $input_file = $this;
			$input_file.off().on('change', function (e) {
				console.log('change���?');
				var $this = $(this);
				var files = e.target.files;
				set_value(files);
			});
			set_value($input_file[0].defaultValue);

			function set_value(value) {
				var _s = '';
				var mx_ln = 3;
				if (typeof value === 'object') {
					if (value.length) {
						for (var i = 0; i < value.length; i++) {
							var fl = '';
							var ot = '';
							var _v = value[i].name;
							if (i) {
								fl = ',';
							}
							if (i >= mx_ln) {
								fl = '';
								_v = '';
								ot = '..[�� ' + (value.length - mx_ln) + '��]';
							}
							_s += fl + _v + ot;
							if (!_v) {
								break;
							}
						}
					} else {
						_s += '���õ� ������ �����ϴ�.';
					}
				} else {
					_s += value;
				}
				$input_text.val(_s);
			}
			/* ui����:E */
		}
		return {
			_ui_set_inputfile: _ui_set_inputfile,
		}
	}
};
