<div class="col-md-12">

	<ul class="nav nav-tabs">
		{%- set orders = [
			'new': 'All discussions',
			'hot': 'Hot',
			'unanswered': 'Unanswered',
			'my': 'My discussions',
			'answers':'My answers'
		] -%}
		{%- for order, label in orders -%}
			{%- if (order == 'my' or order == 'answers') and !session.get('identity') -%}
				{%- continue -%}
			{% endif -%}
			{%- if order == currentOrder -%}
				<li class="active">
			{%- else -%}
				<li>
			{%- endif -%}
				{{ link_to('discussions/' ~ order, label) }}
			</li>
		{%- endfor -%}
	</ul>
</div>

{%- if posts|length -%}
<div class="col-md-12">
	<br/>
	<div align="center">
		<table class="table table-striped list-discussions" width="90%">
			<tr>
				<th> &nbsp; </th>
				<th width="38%">Topic</th>
				<th class="hidden-xs">Users</th>
				<th class="hidden-xs">Category</th>
				<th class="hidden-xs">Replies</th>
				<th class="hidden-xs">Views</th>
				<th class="hidden-xs">Created</th>
				<th class="hidden-xs">Last Reply</th>
			</tr>
		{%- for post in posts -%}
			<tr class="{% if (post.votes_up - post.votes_down) <= -3 %}post-negative{% else %}post-positive{% endif %}">
				<td>
					{%  if config.theme.use_topics_icon %}
						{%- if logged != '' -%}
							{%- if readposts[post.id] is defined -%}
								{{ image(config.theme.inactive_topic_icon, 'width': 24, 'height': 24, 'class': 'img-rounded') }}
							{%- else -%}
								{{ image(config.theme.active_topic_icon, 'width': 24, 'height': 24, 'class': 'img-rounded') }}
							{%- endif -%}
						{%- else -%}
						 {{ image(config.theme.inactive_topic_icon, "width": "24", "height": "24", "class": "img-rounded") }}
						{%- endif -%}
					{%- endif -%}
				</td>
				<td align="left">

					{%- if post.sticked == "Y" -%}
						<span class="glyphicon glyphicon-pushpin"></span>&nbsp;
					{%- endif -%}
					{{- link_to('discussion/' ~ post.id ~ '/' ~ post.slug, post.title|e) -}}
					{%- if post.accepted_answer == "Y" -%}
						&nbsp;<span class="label label-success">SOLVED</span>
					{%- else -%}
						{%- if post.canHaveBounty() -%}
							&nbsp;<span class="label label-info">BOUNTY</span>
						{%- endif -%}
					{%- endif -%}

				</td>
				<td class="hidden-xs">
					{%- cache "post-users-" ~ post.id -%}
						{%- for id, user in post.getRecentUsers() -%}
							<a href="{{ url("user/" ~ id ~ "/" ~ user[0]) }}" title="{{ user[0] }}">
								{{ image(gravatar.getAvatar(user[1]), 'width': 24, 'height': 24, 'class': 'img-rounded') }}
							</a>
						{%- endfor -%}
					{%- endcache -%}
				</td>
				<td class="hidden-xs">
					<span class="category">{{ link_to('category/' ~ post.category.id ~ '/' ~ post.category.slug, post.category.name) }}</span>
				</td>
				<td class="hidden-xs" align="center">
					<span class="big-number">{% if post.number_replies > 0 %}{{ post.number_replies }}{%endif %}</span>
				</td>
				<td class="hidden-xs" align="center">
					<span class="big-number">{{ post.getHumanNumberViews() }}</span>
				</td>
				<td class="hidden-xs">
					<span class="date">{{ post.getHumanCreatedAt() }}</span>
				</td>
				<td class="hidden-xs">
					<span class="date">{{ post.getHumanModifiedAt() }}</span>
				</td>
			</tr>
		{%- endfor -%}
		</table>
	</div>
</div>

<div class="col-md-12">
	<ul class="pager">
		{%- if offset > 0 -%}
			<li class="previous">{{ link_to(paginatorUri ~ '/' ~ (offset - limitPost), 'Prev', 'rel': 'prev') }}</li>
		{%- endif -%}

		{%- if totalPosts.count > limitPost -%}
			<li class="next">{{ link_to(paginatorUri ~ '/' ~ (offset + limitPost), 'Next', 'rel': 'next') }}</li>
		{%- endif -%}
	</ul>
</div>

{%- else -%}
<div class="col-md-12" align="center">
	<div class="alert alert-info">There are no posts here</div>
</div>
{%- endif -%}
