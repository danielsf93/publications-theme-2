{**
 * templates/frontend/objects/monograph_full.tpl
 *}
<div class="obj_monograph_full">

	{* Notification that this is an old version *}
	{if $currentPublication->getID() !== $publication->getId()}
		<div class="cmp_notification notice">
			{capture assign="latestVersionUrl"}{url page="catalog" op="book" path=$monograph->getBestId()}{/capture}
			{translate key="submission.outdatedVersion"
				datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
				urlRecentVersion=$latestVersionUrl|escape
			}
		</div>
	{/if}

	<h1 class="title">
		{$publication->getLocalizedFullTitle()|escape}
	</h1>

<div class="doi">
{* DOI (requires plugin) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$monograph->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentPress->getId(), $pubId)|escape}
					<div class="item doi">
						<span class="label">
							{translate key="plugins.pubIds.doi.readerDisplayName"}
						</span>
						<span class="value">
							<a href="{$doiUrl}">
								{$doiUrl}
							</a>
						</span>
					</div>
				{/if}
			{/foreach}
	</div><br>
	
	
	<div class="row">
		<div class="main_entry">

			{* Author list *}
			<div class="item authors">
				<h2 class="pkp_screen_reader">
					{translate key="submission.authors"}
				</h2>
{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
				<img
					src="{$publication->getLocalizedCoverImageThumbnailUrl($monograph->getData('contextId'))}"
					alt="{$coverImage.altText|escape|default:''}"
				>
				{assign var="authors" value=$publication->getData('authors')}

				{* Only show editors for edited volumes *}
				{if $monograph->getWorkType() == $smarty.const.WORK_TYPE_EDITED_VOLUME && $editors|@count}
					{assign var="authors" value=$editors}
					{assign var="identifyAsEditors" value=true}
				{/if}

				{* Show short author lists on multiple lines *}
				{if $authors|@count < 5}
					{foreach from=$authors item=author}
						<div class="sub_item">
							<div class="label">

							
								{if $identifyAsEditors}
									{translate key="submission.editorName" editorName=$author->getFullName()|escape}
								{else}
									{$author->getFullName()|escape}
								{/if}
							</div>
							{if $author->getLocalizedAffiliation()}
								<div class="value">
									{$author->getLocalizedAffiliation()|escape}
								</div>
							{/if}
							{if $author->getOrcid()}
								<span class="orcid">
									<a href="{$author->getOrcid()|escape}" target="_blank">
										{$author->getOrcid()|escape}
									</a>
								</span>
							{/if}
						</div>
					{/foreach}

				{* Show long author lists on one line *}
				{else}
					{foreach name="authors" from=$authors item=author}
						{* strip removes excess white-space which creates gaps between separators *}
						{strip}
							{if $author->getLocalizedAffiliation()}
								ola{if $identifyAsEditors}
									{capture assign="authorName"}<span class="label">{translate key="submission.editorName" editorName=$author->getFullName()|escape}</span>{/capture}
								{else}
									{capture assign="authorName"}<span class="label">{$author->getFullName()|escape}</span>{/capture}
								{/if}
								{capture assign="authorAffiliation"}<span class="value">{$author->getLocalizedAffiliation()|escape}</span>{/capture}
								{translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliation}
							{else}
								<span class="label">{$author->getFullName()|escape}</span>
							{/if}
							{if !$smarty.foreach.authors.last}
								{translate key="submission.authorListSeparator"}
							{/if}
						{/strip}
					{/foreach}
				{/if}
			</div>
<hr>

<hr>


<style>
    /* Estilo para os botões das abas */
    .tablink {
        background-color: #4CAF50; /* Cor de fundo */
        color: white; /* Cor do texto */
        padding: 15px 30px; /* Espaçamento interno */
        border: none; /* Sem borda */
        cursor: pointer; /* Cursor ao passar */
    }

    /* Estilo para os botões ativos */
    .active {
        background-color: #45a049;
    }

    /* Estilo para o conteúdo das abas */
    .tabcontent {
        display: none; /* Inicia oculto */
        padding: 20px; /* Espaçamento interno */
        border: 0px solid #ccc; /* Borda */
    }
</style>

<div class="page">

    <!-- Abas -->
    <div class="tabs">
        <button class="tablink" onclick="openTab('sinopse')"><b>sinopse</b></button>
        <button class="tablink" onclick="openTab('Palavras-chave')"><b>Palavras-chave</b></button>
		<button class="tablink" onclick="openTab('Citacao')"><b>Citacao</b></button>
    </div>


    <!-- Conteúdo das Abas -->
    <div id="sinopse" class="tabcontent">
       {* Abstract *}
			<div class="item abstract">
				<h2 class="label">
					{translate key="submission.synopsis"}
				</h2>
				<div class="value">
					{$publication->getLocalizedData('abstract')|strip_unsafe_html}
				</div>
			</div>
        
    
    </div>

    <div id="Palavras-chave" class="tabcontent">
        {* Keywords *}
			{if !empty($publication->getLocalizedData('keywords'))}
			<div class="item keywords">
				<h2 class="label">
					{capture assign=translatedKeywords}{translate key="common.keywords"}{/capture}
					{translate key="semicolon" label=$translatedKeywords}
				</h2>
				<span class="value">
					{foreach name="keywords" from=$publication->getLocalizedData('keywords') item=keyword}
						{$keyword|escape}{if !$smarty.foreach.keywords.last}, {/if}
					{/foreach}
				</span>
			</div>
			{/if}
    </div>


<div id="Citacao" class="tabcontent">


{**************************** CITAÇÂO"!!!!!!!!!!!!!!!!! ********************************}




				<div class="item citation">
				 {* ABNT *} <div class="sub_item abnt"> <button id="buttonabnt">ABNT</button>
				<div id="divAbnt" style="display:none;">
				<style>
					#buttonabnt {
					
					font-weight: bold;
					background-color: #ececec;
					color: #076fb1;
					border-radius: 5px;
					border: 100;
					padding: 5px 76px;
					cursor: pointer;
					
					}
				</style>
				<div class="referencia abnt">
				{if $authors|count == 1}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()}.
				{elseif $authors|count == 2}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()}; {$authors[1]->getLocalizedFamilyName()|upper}, {$authors[1]->getLocalizedGivenName()}.
				{elseif $authors|count == 3}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()}; {$authors[1]->getLocalizedFamilyName()|upper}, {$authors[1]->getLocalizedGivenName()}; {$authors[2]->getLocalizedFamilyName()|upper}, {$authors[2]->getLocalizedGivenName()}.
				{elseif $authors|count > 3}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()} et al.
				{/if}
								 
				<b>{$publication->getLocalizedFullTitle()|escape}</b>.
				{$publication->getData('seriesPosition')} {if $series}({$series->getLocalizedFullTitle()}){/if}. 
				{$publication->getLocalizedData('copyrightHolder')}, 
				{$publication->getData('copyrightYear')}. 
				DOI: <a href="{$doiUrl}">{$doiUrl}</a>
				{translate key="plugins.generic.ompcitation.link"}<a href="{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"> {$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}</a> .
				{translate key="plugins.generic.ompcitation.date"}{$smarty.now|date_format:"%e %B. %Y"}.
				
				
			</div> </div> 
			
			<script>
				const buttonabnt = document.getElementById("buttonabnt");
				const divAbnt = document.getElementById("divAbnt");
				buttonabnt.addEventListener("click", function() {
				if (divAbnt.style.display === "none") {
					divAbnt.style.display = "block";
					buttonabnt.innerHTML = "ABNT";
				} else {
					divAbnt.style.display = "none";
					buttonabnt.innerHTML = "ABNT";
				}
				});
			</script>
		</div> {* APA *} <div class="sub_item apa"> <button id="buttonapa">APA</button>
			<div id="divapa" style="display:none;">
				<style>
					#buttonapa {
					font-weight: bold;
					background-color: #ececec;
					color: #076fb1;
					border-radius: 5px;
					border: 100;
					padding: 5px 84px;
					cursor: pointer;
					}
				</style>
				<div class="referencia apa">
				{if $authors|count == 1}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}.
				{elseif $authors|count == 2}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}, & {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}.
				{elseif $authors|count == 3}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}, {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}, & {$authors[2]->getLocalizedFamilyName()}, {$authors[2]->getLocalizedGivenName()}.
				{elseif $authors|count == 4}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}; {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}; {$authors[2]->getLocalizedFamilyName()}, {$authors[2]->getLocalizedGivenName()} & {$authors[3]->getLocalizedFamilyName()}, {$authors[3]->getLocalizedGivenName()}.
				{elseif $authors|count == 5}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}; {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}; {$authors[2]->getLocalizedFamilyName()}, {$authors[2]->getLocalizedGivenName()}; {$authors[3]->getLocalizedFamilyName()}, {$authors[3]->getLocalizedGivenName()} & {$authors[4]->getLocalizedFamilyName()}, {$authors[4]->getLocalizedGivenName()}.
				{elseif $authors|count > 5}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()} et al.
				{/if}
					({$publication->getData('copyrightYear')}). 
					<b>{$publication->getLocalizedFullTitle()|escape}</b>. 
					 {$publication->getData('seriesPosition')}.
					 {$publication->getLocalizedData('copyrightHolder')}.
					 DOI: <a href="{$doiUrl}">{$doiUrl}</a>
					 {translate key="plugins.generic.ompcitation.link"}<a href="{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"> {$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}</a> .
					 {translate key="plugins.generic.ompcitation.date"}{$smarty.now|date_format:"%e %b. %Y"}.
				</div>
			</div>
			<script>
				const buttonapa = document.getElementById("buttonapa");
				const divapa = document.getElementById("divapa");
				
				buttonapa.addEventListener("click", function() {
				if (divapa.style.display === "none") {
				divapa.style.display = "block";
				buttonapa.innerHTML = "APA";
				} else {
				divapa.style.display = "none";
				buttonapa.innerHTML = "APA";
				}
				});
			</script><br>
		</div> {* ISO *} <div class="sub_item iso"> <button id="buttoniso">ISO</button>
			<div id="diviso" style="display:none;">
				<style>
					#buttoniso {
					font-weight: bold;
					background-color: #ececec;
					color: #076fb1;
					border-radius: 5px;
					border: 100;
					padding: 5px 85px;
					cursor: pointer;
					}
				</style>
				<div class="referencia iso">
				{if $authors|count == 1}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()|substr:0:1}.
				{elseif $authors|count == 2}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()} e {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}.
				{elseif $authors|count == 3}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()}; {$authors[1]->getLocalizedFamilyName()|upper}, {$authors[1]->getLocalizedGivenName()} e {$authors[2]->getLocalizedFamilyName()|upper}, {$authors[2]->getLocalizedGivenName()}.
				{elseif $authors|count > 3}
					{$authors[0]->getLocalizedFamilyName()|upper}, {$authors[0]->getLocalizedGivenName()} et al.
				{/if}
					<b>{$publication->getLocalizedFullTitle()|escape}</b> 
					{$publication->getData('seriesPosition')} {if $series}({$series->getLocalizedFullTitle()}){/if}.
					{$publication->getLocalizedData('copyrightHolder')}, 
					{$publication->getData('copyrightYear')}.
					DOI: <a href="{$doiUrl}">{$doiUrl}</a>
					[{translate key="plugins.generic.ompcitation.date"}{$smarty.now|date_format:"%e %B. %Y"}.]
					{translate key="plugins.generic.ompcitation.link"}<a href="{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"> {$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}</a> </p>
				</div>
			</div>
			<script>
				const buttoniso = document.getElementById("buttoniso");
				const diviso = document.getElementById("diviso");
				
				buttoniso.addEventListener("click", function() {
				if (diviso.style.display === "none") {
				diviso.style.display = "block";
				buttoniso.innerHTML = "ISO";
				} else {
				diviso.style.display = "none";
				buttoniso.innerHTML = "ISO";
				}
				});
			</script>
		</div> {* VANCOUVER *} <div class="sub_item vancouver"> <button id="buttonvancouver">Vancouver</button>
			<div id="divvancouver" style="display:none;">
				<style>
					#buttonvancouver {
					font-weight: bold;
					background-color: #ececec;
					color: #076fb1;
					border-radius: 5px;
					border: 100;
					padding: 5px 60px;
					cursor: pointer;
					}
				</style>
				<div class="referencia vancouver">
				{if $authors|count == 1}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()|substr:0:1}.
				{elseif $authors|count == 2}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()}, {$authors[1]->getLocalizedFamilyName()}, {$authors[1]->getLocalizedGivenName()}.
				{elseif $authors|count == 3}
					{$authors[0]->getLocalizedFamilyName()} {$authors[0]->getLocalizedGivenName()|substr:0:1}, {$authors[1]->getLocalizedFamilyName()} {$authors[1]->getLocalizedGivenName()|substr:0:1}, {$authors[2]->getLocalizedFamilyName()} {$authors[2]->getLocalizedGivenName()|substr:0:1}.
				{elseif $authors|count > 3}
					{$authors[0]->getLocalizedFamilyName()}, {$authors[0]->getLocalizedGivenName()} et al.
				{/if}

				 <b>{$publication->getLocalizedFullTitle()|escape}.</b> 
				 {$publication->getLocalizedData('copyrightHolder')}, 
				 c{$publication->getData('copyrightYear')}. 
				 [{translate key="plugins.generic.ompcitation.vanc"}{$smarty.now|date_format:"%e de %B %Y"}].
				 DOI: <a href="{$doiUrl}">{$doiUrl}</a> 
				 {translate key="plugins.generic.ompcitation.link"}<a href="{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"> {$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}</a> 
				 
				 </p>
				</div>
			</div>
			<script>
				const buttonvancouver = document.getElementById("buttonvancouver");
				const divvancouver = document.getElementById("divvancouver");
				
				buttonvancouver.addEventListener("click", function() {
				if (divvancouver.style.display === "none") {
				divvancouver.style.display = "block";
				buttonvancouver.innerHTML = "Vancouver";
				} else {
				divvancouver.style.display = "none";
				buttonvancouver.innerHTML = "Vancouver";
				}
				});
			</script>
		</div>
		</div>
				{**************************** FINAL de CITAÇÂO"!!!!!!!!!!!!!!!!! ********************************}







    </div>







</div>


<!-- Script para alternar entre as abas -->
<script>
    function openTab(tabName) {
        var i;
        var x = document.getElementsByClassName("tabcontent");
        for (i = 0; i < x.length; i++) {
            x[i].style.display = "none";
        }

        var tablinks = document.getElementsByClassName("tablink");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].classList.remove("active");
        }

        document.getElementById(tabName).style.display = "block";
        event.currentTarget.classList.add("active");
    }
</script>




<hr>







<hr>
			

			

			
<hr>





<hr>
			{* Chapters *}
			{if $chapters|@count}
				<div class="item chapters">
					<h2 class="pkp_screen_reader">
						{translate key="submission.chapters"}
					</h2>
					<ul>
						{foreach from=$chapters item=chapter}
							{assign var=chapterId value=$chapter->getId()}
							<li>
								<div class="title">
									{$chapter->getLocalizedTitle()|escape}
									{if $chapter->getLocalizedSubtitle() != ''}
										<div class="subtitle">
											{$chapter->getLocalizedSubtitle()|escape}
										</div>
									{/if}
								</div>
								{assign var=chapterAuthors value=$chapter->getAuthorNamesAsString()}
								{if $authorString != $chapterAuthors}
									<div class="authors">
										{$chapterAuthors|escape}
									</div>
								{/if}

								{* DOI (requires plugin) *}
								{foreach from=$pubIdPlugins item=pubIdPlugin}
									{if $pubIdPlugin->getPubIdType() != 'doi'}
										{continue}
									{/if}
									{assign var=pubId value=$chapter->getStoredPubId($pubIdPlugin->getPubIdType())}
									{if $pubId}
										{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentPress->getId(), $pubId)|escape}
										<div class="doi">{translate key="plugins.pubIds.doi.readerDisplayName"} <a href="{$doiUrl}">{$doiUrl}</a></div>
									{/if}
								{/foreach}

								{* Display any files that are assigned to this chapter *}
								{pluck_files assign="chapterFiles" files=$availableFiles by="chapter" value=$chapterId}
								{if $chapterFiles|@count}
									<div class="files">

										{* Display chapter files sorted by publication format so that they are ordered
										   consistently across all chapters. *}
										{foreach from=$publicationFormats item=format}
											{pluck_files assign="pubFormatFiles" files=$chapterFiles by="publicationFormat" value=$format->getId()}

											{foreach from=$pubFormatFiles item=file}

												{* Use the publication format name in the download link unless a pub format has multiple files *}
												{assign var=useFileName value=false}
												{if $pubFormatFiles|@count > 1}
													{assign var=useFileName value=true}
												{/if}

												{include file="frontend/components/downloadLink.tpl" downloadFile=$file monograph=$monograph publicationFormat=$format currency=$currency useFilename=$useFileName}
											{/foreach}
										{/foreach}
									</div>
								{/if}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}

			{call_hook name="Templates::Catalog::Book::Main"}

			{* Determine if any authors have biographies to display *}
			{assign var="hasBiographies" value=0}
			{foreach from=$publication->getData('authors') item=author}
				{if $author->getLocalizedBiography()}
					{assign var="hasBiographies" value=$hasBiographies+1}
				{/if}
			{/foreach}
			{if $hasBiographies}
				<div class="item author_bios">
					<h2 class="label">
						{if $hasBiographies > 1}
							{translate key="submission.authorBiographies"}
						{else}
							{translate key="submission.authorBiography"}
						{/if}
					</h2>
					{foreach from=$publication->getData('authors') item=author}
						{if $author->getLocalizedBiography()}
							<div class="sub_item">
								<div class="label">
									{if $author->getLocalizedAffiliation()}
										{capture assign="authorName"}{$author->getFullName()|escape}{/capture}
										{capture assign="authorAffiliation"}<span class="affiliation">{$author->getLocalizedAffiliation()|escape}</span>{/capture}
										{translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliation}
									{else}
										{$author->getFullName()|escape}
									{/if}
								</div>
								<div class="value">
									{$author->getLocalizedBiography()|strip_unsafe_html}
								</div>
							</div>
						{/if}
					{/foreach}
				</div>
			{/if}
			
			{* References *}
			{if $citations || $publication->getData('citationsRaw')}
				<div class="item references">
					<h2 class="label">
						{translate key="submission.citations"}
					</h2>
					<div class="value">
						{if $citations}
							{foreach from=$citations item=$citation}
								<p>{$citation->getCitationWithLinks()|strip_unsafe_html}</p>
							{/foreach}
						{else}
							{$publication->getData('citationsRaw')|escape|nl2br}
						{/if}
					</div>
				</div>
			{/if}

		</div><!-- .main_entry -->

		<div class="entry_details">

			

			{* Any non-chapter files and remote resources *}
			{pluck_files assign=nonChapterFiles files=$availableFiles by="chapter" value=0}
			{if $nonChapterFiles|@count || $remotePublicationFormats|@count}
				<div class="item files">
					<h2 class="pkp_screen_reader">
						{translate key="submission.downloads"}
					</h2>
					{foreach from=$publicationFormats item=format}
						{assign var=publicationFormatId value=$format->getId()}

						{* Remote resources *}
						{if $format->getRemoteUrl()}
							{* Only one resource allowed per format, so mimic single-file-download *}
							<div class="pub_format_{$publicationFormatId|escape} pub_format_remote">
								<a href="{$format->getRemoteURL()|escape}" target="_blank" class="remote_resource">
									{$format->getLocalizedName()|escape}
								</a>
							</div>

						{* File downloads *}
						{else}

							{* Only display files that haven't been displayed in a chapter *}
							{pluck_files assign=pubFormatFiles files=$nonChapterFiles by="publicationFormat" value=$format->getId()}

							{* Use a simplified presentation if only one file exists *}
							{if $pubFormatFiles|@count == 1}
								<div class="pub_format_{$publicationFormatId|escape} pub_format_single">
									{foreach from=$pubFormatFiles item=file}
										{include file="frontend/components/downloadLink.tpl" downloadFile=$file monograph=$monograph publication=$publication publicationFormat=$format currency=$currency}
									{/foreach}
								</div>

							{* Use an itemized presentation if multiple files exist *}
							{elseif $pubFormatFiles|@count > 1}
								<div class="pub_format_{$publicationFormatId|escape}">
									<span class="label">
										{$format->getLocalizedName()|escape}
									</span>
									<span class="value">
										<ul>
											{foreach from=$pubFormatFiles item=file}
												<li>
													<span class="name">
														{$file->getLocalizedData('name')|escape}
													</span>
													<span class="link">
														{include file="frontend/components/downloadLink.tpl" downloadFile=$file monograph=$monograph publication=$publication publicationFormat=$format currency=$currency useFilename=true}
													</span>
												</li>
											{/foreach}
										</ul>
									</span><!-- .value -->
								</div>
							{/if}
						{/if}
					{/foreach}{* Publication formats loop *}
				</div>
			{/if}

			{* Publication Date *}
			{if $publication->getData('datePublished')}
				<div class="item date_published">
					<div class="sub_item">
						<h2 class="label">
							{if $publication->getData('datePublished')|date_format:$dateFormatShort > $smarty.now|date_format:$dateFormatShort}
								{translate key="catalog.forthcoming"}
							{else}
								{translate key="catalog.published"}
							{/if}
						</h2>
						<div class="value">
							{* If this is the original version *}
							{if $firstPublication->getID() === $publication->getId()}
								<span>{$firstPublication->getData('datePublished')|date_format:$dateFormatLong}</span>
							{* If this is an updated version *}
							{else}
								<span>{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatLong dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatLong}</span>
							{/if}
						</div>
					</div>
					{if count($monograph->getPublishedPublications()) > 1}
						<div class="sub_item versions">
							<h2 class="label">
								{translate key="submission.versions"}
							</h2>
							<ul class="value">
								{foreach from=array_reverse($monograph->getPublishedPublications()) item=iPublication}
									{capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
									<li>
										{if $iPublication->getId() === $publication->getId()}
											{$name}
										{elseif $iPublication->getId() === $currentPublication->getId()}
											<a href="{url page="catalog" op="book" path=$monograph->getBestId()}">{$name}</a>
										{else}
											<a href="{url page="catalog" op="book" path=$monograph->getBestId()|to_array:"version":$iPublication->getId()}">{$name}</a>
										{/if}
									</li>
								{/foreach}
							</ul>
						</div>
					{/if}
				</div>
			{/if}

			{* Series *}
			{if $series}
				<div class="item series">
					<div class="sub_item">
						<h2 class="label">
							{translate key="series.series"}
						</h2>
						<div class="value">
							<a href="{url page="catalog" op="series" path=$series->getPath()}">
								{$series->getLocalizedFullTitle()|escape}
							</a>
						</div>
					</div>
					{if $series->getOnlineISSN()}
						<div class="sub_item">
							<h3 class="label">{translate key="catalog.manage.series.onlineIssn"}</h3>
							<div class="value">{$series->getOnlineISSN()|escape}</div>
						</div>
					{/if}
					{if $series->getPrintISSN()}
						<div class="sub_item">
							<h3 class="label">{translate key="catalog.manage.series.printIssn"}</h3>
							<div class="value">{$series->getPrintISSN()|escape}</div>
						</div>
					{/if}
				</div>
			{/if}

			{* Categories *}
			{if $categories}
				<div class="item categories">
					<h2 class="label">
						{translate key="catalog.categories"}
					</h2>
					<div class="value">
						<ul>
							{foreach from=$categories item="category"}
								<li>
									<a href="{url op="category" path=$category->getPath()}">
										{$category->getLocalizedTitle()|strip_unsafe_html}
									</a>
								</li>
							{/foreach}
						</ul>
					</div>
				</div>
			{/if}

			
				



{* Copyright statement *}
			{if $publication->getData('copyrightYear') && $publication->getLocalizedData('copyrightHolder')}
				<div class="item copyright">
					{translate|escape key="submission.copyrightStatement" copyrightYear=$publication->getData('copyrightYear') copyrightHolder=$publication->getLocalizedData('copyrightHolder')}
				</div>
			{/if}

			{* License *}
			{if $publication->getData('licenseUrl')}
				<div class="item license">
					<h2 class="label">
						{translate key="submission.license"}
					</h2>
					{if $ccLicenseBadge}
						{$ccLicenseBadge}
					{else}
						<a href="{$publication->getData('licenseUrl')|escape}">
							{translate key="submission.license"}
						</a>
					{/if}
				</div>
			{/if}

			{* Publication formats *}
			{if count($publicationFormats)}
				{foreach from=$publicationFormats item="publicationFormat"}
					{if $publicationFormat->getIsApproved()}

						{assign var=identificationCodes value=$publicationFormat->getIdentificationCodes()}
						{assign var=identificationCodes value=$identificationCodes->toArray()}
						{assign var=publicationDates value=$publicationFormat->getPublicationDates()}
						{assign var=publicationDates value=$publicationDates->toArray()}
						{assign var=hasPubId value=false}
						{foreach from=$pubIdPlugins item=pubIdPlugin}
							{assign var=pubIdType value=$pubIdPlugin->getPubIdType()}
							{if $publicationFormat->getStoredPubId($pubIdType)}
								{assign var=hasPubId value=true}
								{break}
							{/if}
						{/foreach}

						{* Skip if we don't have any information to print about this pub format *}
						{if !$identificationCodes && !$publicationDates && !$hasPubId && !$publicationFormat->getPhysicalFormat()}
							{continue}
						{/if}

						<div class="item publication_format">

							{* Only add the format-specific heading if multiple publication formats exist *}
							{if count($publicationFormats) > 1}
								<h2 class="pkp_screen_reader">
									{assign var=publicationFormatName value=$publicationFormat->getLocalizedName()}
									{translate key="monograph.publicationFormatDetails" format=$publicationFormatName|escape}
								</h2>

								<div class="sub_item item_heading format">
									<div class="label">
										{$publicationFormat->getLocalizedName()|escape}
									</div>
								</div>
							{else}
								<h2 class="pkp_screen_reader">
									{translate key="monograph.miscellaneousDetails"}
								</h2>
							{/if}


							{* DOI's and other identification codes *}
							{if $identificationCodes}
								{foreach from=$identificationCodes item=identificationCode}
									<div class="sub_item identification_code">
										<h3 class="label">
											{$identificationCode->getNameForONIXCode()|escape}
										</h3>
										<div class="value">
											{$identificationCode->getValue()|escape}
										</div>
									</div>
								{/foreach}
							{/if}

							{* Dates of publication *}
							{if $publicationDates}
								{foreach from=$publicationDates item=publicationDate}
									<div class="sub_item date">
										<h3 class="label">
											{$publicationDate->getNameForONIXCode()|escape}
										</h3>
										<div class="value">
											{assign var=dates value=$publicationDate->getReadableDates()}
											{* note: these dates have dateFormatShort applied to them in getReadableDates() if they need it *}
											{if $publicationDate->isFreeText() || $dates|@count == 1}
												{$dates[0]|escape}
											{else}
												{* @todo the &mdash; ought to be translateable *}
												{$dates[0]|escape}&mdash;{$dates[1]|escape}
											{/if}
											{if $publicationDate->isHijriCalendar()}
												<div class="hijri">
													{translate key="common.dateHijri"}
												</div>
											{/if}
										</div>
									</div>
								{/foreach}
							{/if}

							{* PubIDs *}
							{foreach from=$pubIdPlugins item=pubIdPlugin}
								{assign var=pubIdType value=$pubIdPlugin->getPubIdType()}
								{assign var=storedPubId value=$publicationFormat->getStoredPubId($pubIdType)}
								{if $storedPubId != ''}
									<div class="sub_item pubid {$publicationFormat->getId()|escape}">
										<h2 class="label">
											{$pubIdType}
										</h2>
										<div class="value">
											{$storedPubId|escape}
										</div>
									</div>
								{/if}
							{/foreach}

							{* Physical dimensions *}
							{if $publicationFormat->getPhysicalFormat()}
								<div class="sub_item dimensions">
									<h2 class="label">
										{translate key="monograph.publicationFormat.productDimensions"}
									</h2>
									<div class="value">
										{$publicationFormat->getDimensions()|escape}
									</div>
								</div>
							{/if}
						</div>
					{/if}
				{/foreach}
			{/if}

			{call_hook name="Templates::Catalog::Book::Details"}
			
		</div><!-- .details -->
	</div><!-- .row -->

</div><!-- .obj_monograph_full -->